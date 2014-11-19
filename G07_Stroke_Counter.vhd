library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity G07_Stroke_Counter is

	port(
		clock,reset,TPULSE,SPULSE: in std_logic;
		STROKE_COUNT: out std_logic_vector(13 downto 0);
		STROKE_RATE: out  std_logic_vector( 7 downto 0) );

end G07_Stroke_Counter;

architecture behv of G07_Stroke_Counter is

	signal strkcnt : std_logic_vector( 13 downto 0);


begin
	
	STROKE_COUNT <= strkcnt; 
	
	process(clock, reset)
		variable cnt : integer := 0;
		variable rate_cnt : std_logic_vector( 7 downto 0);
		variable splast : std_logic;
	begin
		if(reset = '1') then
			cnt := 0;
			rate_cnt := std_logic_vector(to_unsigned(0,8));
			strkcnt <= std_logic_vector(to_unsigned(0,14));
			STROKE_RATE <= std_logic_vector(to_unsigned(0,8));
			splast := '0';

		elsif(rising_edge(clock)) then --only true when transitioning from 0 to 1
			if(TPULSE = '1') then
				cnt := cnt + 1;
			end if;
			if(cnt = 60) then
				cnt := 0;
				STROKE_RATE <=  rate_cnt;
				rate_cnt := std_logic_vector(to_unsigned(0,8));
			end if;
			if((SPULSE = '1') AND (splast = '0')) then
				rate_cnt := std_logic_vector(unsigned(rate_cnt) + to_unsigned(1,8));
				strkcnt <= std_logic_vector(unsigned(strkcnt) + to_unsigned(1,8));
			end if;
			splast := SPULSE;
		end if;
	end process;

end behv;