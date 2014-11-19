library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity g07_serial_binary_to_bcd is 
	port ( clk, start, reset : in std_logic;
		   BIN : in unsigned(13 downto 0);
		   ready : out std_logic;
		   BCD4, BCD3, BCD2, BCD1 : out std_logic_vector(3 downto 0));
end g07_serial_binary_to_bcd;

architecture behv of g07_serial_binary_to_bcd is
	signal regout : std_logic_vector(15 downto 0);
	signal regin  : std_logic_vector(15 downto 0);
	signal shiftin : std_logic;
	
	component g07_ADD3 is
		port (	x4,x3,x2,x1 : in std_logic;
				y4,y3,y2,y1 : out std_logic );
	end component;
	
begin
	--16-bit register
	--	function(on clock edge):
	--		1) write data input values into register
	--		2) shift in shift input
	bcd16_reg : process(clk, reset)
		variable count : integer;
	begin
		if(reset = '1') then
			regout <= std_logic_vector(to_unsigned(0,16));
			count  := 0;
			ready <= '0';
		elsif(rising_edge(clk)) then
			if(start = '1') then
				regout <= std_logic_vector(to_unsigned(0,16));
				count := 0;
				ready <='0';
--			--infer memory, no default value for memory or regout
			elsif(count < 15) then
				count := count + 1;
				regout <= regin(14 downto 0)&shiftin;
				if(count = 15) then
					ready <= '1';
				end if;
			end if;	
		end if;
	end process;
	
	bin14_reg : process(clk, reset)
		--infer memory on memory variable
		variable binreg : std_logic_vector(13 downto 0);
	begin
		if(reset = '1') then
			binreg := std_logic_vector(to_unsigned(0,14));
		elsif(rising_edge(clk)) then
			if(start = '1') then
				binreg := std_logic_vector(BIN);
			else
				shiftin <= binreg(13); --this is the shift out, which is set to the shift in to the bcd register
				binreg(13 downto 1) := binreg(12 downto 0); --shift up
				binreg(0) := '0';
			end if;
		end if;
	end process;
	
	add3_3 : g07_ADD3 port map ( 	x4=>regout(15),x3=>regout(14),x2=>regout(13),x1=>regout(12),
						y4=>regin(15),y3=>regin(14),y2=>regin(13),y1=>regin(12)	);
	add3_2 : g07_ADD3 port map( 	x4=>regout(11),x3=>regout(10),x2=>regout(9),x1=>regout(8),
					y4=>regin(11),y3=>regin(10),y2=>regin(9),y1=>regin(8)	);	
	add3_1 : g07_ADD3 port map( 	x4=>regout(7),x3=>regout(6),x2=>regout(5),x1=>regout(4),
					y4=>regin(7),y3=>regin(6),y2=>regin(5),y1=>regin(4)	);
	add3_0 : g07_ADD3 port map( 	x4=>regout(3),x3=>regout(2),x2=>regout(1),x1=>regout(0),
					y4=>regin(3),y3=>regin(2),y2=>regin(1),y1=>regin(0)	);
					
	BCD4 <= regout(15 downto 12);
	BCD3 <= regout(11 downto  8);
	BCD2 <= regout(7  downto  4);
	BCD1 <= regout(3  downto  0);
	
end behv;