library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library lpm;
use lpm.lpm_components.all;

Entity g07_SECONDS_TIMER is

	port(	reset, clock, enable	:	in 	std_logic;
			TPULSE					:	out	std_logic
		);
	
end g07_SECONDS_TIMER;

architecture behv of g07_SECONDS_TIMER is

	signal lpm_constant, q 	: std_logic_vector( 39 downto 0);
	signal sload, pulse 	: std_logic;
	
begin
	
	lpm_constant <= std_logic_vector(to_unsigned(49999999,40));
--	lpm_constant <= std_logic_vector(to_unsigned(499,40));
	sload <= pulse OR reset;
	pulse <= '1' when unsigned(q) = 0 else '0';
	
	TPULSE <= pulse;
	
	counter : LPM_COUNTER 
		generic map( LPM_width => 40, LPM_direction => "DOWN")
		port map( data => lpm_constant, sload => sload, clock => clock, cnt_en => enable, q => q );
	
end behv;