library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lpm;
use lpm.lpm_components.all;

Entity G07_Lab3 is

	port(	clk, en, reset			: in 	std_logic;
			stroke_in               : in 	std_logic;
			count     				: out 	std_logic_vector(13 downto 0);
			rate					: out	std_logic_vector(7 downto 0)
		);

end G07_Lab3;

architecture behv of G07_Lab3 is
	
	signal pulse			: std_logic;
	signal count_out, load	: std_logic_vector( 12 downto 0 );
	signal BCD_in 			: std_logic_vector( 13 downto 0 );
	
	component g07_SECONDS_TIMER is
		port(	reset, clock, enable	:	in 	std_logic;
				TPULSE					:	out	std_logic
			);
	end component;
	
	component G07_Stroke_Counter is
		port(
			clock,reset,TPULSE,SPULSE: in std_logic;
			STROKE_COUNT: out std_logic_vector(13 downto 0);
			STROKE_RATE: out  std_logic_vector( 7 downto 0) );
	end component;
	
begin

	BCD_in 	<= '0'&count_out;
	load	<= std_logic_vector(to_unsigned(0,13));
	
	pulser  : g07_SECONDS_TIMER port map(reset => reset, clock => clk, enable => en, TPULSE => pulse);

	stroke_counter : g07_stroke_counter port map(clock => clk, reset => reset, TPULSE => pulse, SPULSE => stroke_in, STROKE_COUNT => count, STROKE_RATE => rate);
	
	
end behv;