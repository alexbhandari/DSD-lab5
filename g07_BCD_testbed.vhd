library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity g07_BCD_testbed is 
	port ( clk, start, reset : in std_logic;
		   BIN : in std_logic_vector(8 downto 0);
		   ready : out std_logic;
		   out4, out3, out2, out1 : out std_logic_vector(6 downto 0));
end g07_BCD_testbed;

architecture behv of g07_BCD_testbed is

	signal x1, x2, x3, x4 : std_logic_vector(3 downto 0);
	signal binfull : std_logic_vector(13 downto 0);
	signal bun : unsigned(13 downto 0);

	component g07_serial_binary_to_bcd is
		port ( clk, start, reset : in std_logic;
		   BIN : in unsigned(13 downto 0);
		   ready : out std_logic;
		   BCD4, BCD3, BCD2, BCD1 : out std_logic_vector(3 downto 0));
	end component;

	component g07_7_segment_decoder_full is
		port ( BCD1, BCD2, BCD3, BCD4  : in std_logic_vector(3 downto 0);
	   		   seg1,seg2,seg3,seg4     : out std_logic_vector(6 downto 0));
	end component;
	
	begin

	
	binfull <= "0"&(BIN)&"0000";
	bun <= unsigned(binfull);

	converter : g07_serial_binary_to_bcd port map(clk => clk,
												   BIN => bun,
												   ready => ready,
												   reset => reset,
												   start => start,
												   BCD1 =>x1,
												   BCD2 =>x2,
												   BCD3 =>x3,
												   BCD4 =>x4);

	decoder : g07_7_segment_decoder_full port map(BCD1 => x1,
												  BCD2 => x2,
												  BCD3 => x3,
												  BCD4 => x4,
												  seg1 => out1,
												  seg2 => out2,
												  seg3 => out3,
												  seg4 => out4);

end behv;