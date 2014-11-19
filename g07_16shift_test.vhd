library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity g07_16shift_test is 

	port(reset,clk,shiftin,start : in std_logic;
		 regin : in std_logic_vector(15 downto 0);
		 regout : buffer std_logic_vector(15 downto 0);
		 ready : out std_logic );

end g07_16shift_test;


architecture behv of g07_16shift_test is

begin
	
	bcd16_reg : process(clk, reset)
		variable count : integer;
		variable prev_start : std_logic := '0';
	begin
		if(reset = '1') then
			regout <= std_logic_vector(to_unsigned(0,16));
			count  := 0;
		elsif(rising_edge(clk)) then
		
		
			if((start AND not prev_start)='1') then
				prev_start := start;
				regout <= std_logic_vector(to_unsigned(0,16));
				count := 0;
			end if;
			--infer memory, no default value for memory or regout
--			--1) write memory
--			regout <= regin;
--			--2) shift
--			for n in 1 to 15 loop
--				regout(n) <= regout(n-1);
--			end loop;
--			regout(0) <= shiftin;
			regout <= regin(14 downto 0)&shiftin;
			count := count + 1;
			if(count = 15) then
				ready <= '1';
			end if;
		end if;
	end process;
	
end behv;