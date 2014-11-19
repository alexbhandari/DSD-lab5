Library ieee;
use ieee.std_logic_ll64.all;
use ieee.numeric.all;

Entity g07_lab5 is

	port(
	clk, en, stroke_button,reset_button,start_stop_button : in std_logic;
	rowing_power_switch : in unsigned(3 downto 0);
	value_switch		: in unsigned(2 downto 0)
	);
	
end g07_lab5;

architecture behv of g07_lab5 is

-- • Exercise time (in minutes and seconds – maximum is 99 min, 59 sec)		- 
	--signal etime	: std_logic_vector()
-- • Total stroke count since beginning of exercise period (maximum 9999)	-
	signal strokes 	: std_logic_vector(13 downto 0);
-- • Current boat speed (in meters per second)								- 
	signal speed	: std_logic_vector(11 downto 0);
-- • Total distance covered (in meters) since beginning of exercise period	- 
	--signal distance	: std_logic_vector();
-- • Current stroke rate (strokes made in the previous 60 second interval)	- 
	signal rate 	: std_logic_vector(7 downto 0);
-- • Pace (Time elapsed in seconds for the previous 500 meters interval)	- 
	--signal pace		: std_logic_vector()
-- • Total number of calories burned (in calories)							- 
--	signal calories : std_logic_vector(11 downto 0);
-- • Calorie burn rate (in kilocalories per hour)							- 
	signal kcal_rate : std_logic_vector(11 downto 0);

	component g07_speed_calories
		port ( clk : in std_logic;
			ROWER_POWER : in unsigned(3 downto 0);
			BOAT_SPEED, CALORIE_RATE : out unsigned(11 downto 0));
	end component;
	
	component G07_Lab3
		port(	clk, en, reset		: in 	std_logic;
			stroke_in               : in 	std_logic;
			count     				: out 	std_logic_vector(13 downto 0);
			rate					: out	std_logic_vector(7 downto 0)
		);
	end component;

	component controller
		port(	clk,reset,en : std_logic;
				--etime	: std_logic_vector()
				switch 	: in std_logic_vector(3 downto 0);
				strokes : in std_logic_vector(13 downto 0);
				speed	: in std_logic_vector(11 downto 0);
				--distance	: in std_logic_vector();
				rate 	: in std_logic_vector(7 downto 0);
				--pace		: in std_logic_vector()
				--calories : in std_logic_vector(11 downto 0);
				kcal_rate : in std_logic_vector(11 downto 0);
				seg1,seg2,seg3,seg4     : out std_logic_vector(6 downto 0)
			);
	end component;

begin

	stroke_stats 	: G07_Lab3				port map (clk => clk, en => en, reset => reset_button, stroke_in => stroke_button,
														BOAT_SPEED => speed, CALORIE_RATE => kcal_rate);
	power_stats		: g07_speed_calories	port map (clk => clk, ROWER_POWER => rowing_power_switch --might want to add reset
														count => strokes, rate => rate);
	controller		: g07_controller		port map (clk => clk, en => en, reset => reset,
														switch => value_switch, strokes => strokes, speed => speed,
														rate => rate, kcal_rate => kcal_rate,
														seg1 => seg1, seg2 => seg2, seg3 => seg3, seg4 =< seg4);

end behv;