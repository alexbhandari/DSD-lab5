library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity g07_controller is
	port(	clk,reset,en	: in std_logic;
			--etime	: std_logic_vector()
			switch 	: in unsigned(2 downto 0);
			strokes : in std_logic_vector(13 downto 0);
			speed	: in std_logic_vector(11 downto 0);
			--distance	: in std_logic_vector();
			rate 	: in std_logic_vector(7 downto 0);
			--pace		: in std_logic_vector()
			--calories : in std_logic_vector(11 downto 0);
			kcal_rate : in std_logic_vector(11 downto 0);
			seg1,seg2,seg3,seg4     : out std_logic_vector(6 downto 0)
		);

end g07_controller;

architecture behv of g07_controller is

	component g07_BCD_testbed is 
		port ( clk, start, reset : in std_logic;
			   BIN : in std_logic_vector(13 downto 0);
			   ready : out std_logic;
			   out4, out3, out2, out1 : out std_logic_vector(6 downto 0));
	end component;

	signal dseg1,dseg2,dseg3,dseg4	: std_logic_vector(6 downto 0);
	signal start, load				: std_logic;
	signal mux_out					: std_logic_vector(13 downto 0);

begin

	decoder : g07_BCD_testbed	port map (clk => clk, start => start, reset => reset, BIN => mux_out, 
											ready => load, out1 => dseg1, out2 => dseg2, out3 => dseg3, out4 => dseg4 );

	with switch select
		mux_out <=		std_logic_vector(to_unsigned(0,14)) 	when to_unsigned(0,3), --time
						strokes 								when to_unsigned(1,3),
						"00"&speed	 							when to_unsigned(2,3),
						std_logic_vector(to_unsigned(0,14)) 	when to_unsigned(3,3), --distance
						"000000"&rate			 	 			when to_unsigned(4,3),
						std_logic_vector(to_unsigned(0,14)) 	when to_unsigned(5,3), --pace
						std_logic_vector(to_unsigned(0,14)) 	when to_unsigned(6,3), --calories
						"00"&kcal_rate 							when to_unsigned(7,3),
						std_logic_vector(to_unsigned(0,14))		when OTHERS;

	load_outputs : process(clk) begin
		if(rising_edge(clk) and (load = '1')) then
			seg1 <= dseg1;
			seg2 <= dseg2;
			seg3 <= dseg3;
			seg4 <= dseg4;
		end if;
	end process;

end behv;