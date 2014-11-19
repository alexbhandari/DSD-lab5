-- this circuit takes in a binary 4-bit number and ouputs the corresponding 7 segment code
--
-- entity name: g07_7_segment_decoder
--
-- Copyright (C) 2014 Jacob Barnett and Alex Bhandari-Young
-- Version 1.0
-- Authors: Jacob Barnett (jacob.barnet@mail.mcgill.ca) and Alex Bhandari-Young (alex.bhandari@mail.mcgill.ca)
-- Date: October 9, 2014
library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;

entity g07_7_segment_decoder is
port ( code : in std_logic_vector(3 downto 0);
	RippleBlank_In : in std_logic;
	RippleBlank_Out : out std_logic;
	segments : out std_logic_vector(6 downto 0));
end g07_7_segment_decoder;

architecture behv of g07_7_segment_decoder is

signal isZero : std_logic;
signal isZero_vector : std_logic_vector(3 downto 0);
signal blank_out : std_logic;
signal ZERO,ONE,TWO,THREE,FOUR,FIVE,SIX,SEVEN,EIGHT,NINE,TEN,ELEVEN,TWELVE,THIRTEEN,FOURTEEN,FIFTEEN,DASH,BLANK : std_logic_vector(6 downto 0);
signal blank_code : std_logic_vector(4 downto 0);

begin 
	--codes        "6543210" <- segments (one is on as bits are inverted before assignment)
	ZERO     <= not "0111111";
	ONE      <= not "0000110";
	TWO      <= not "1011011";
	THREE    <= not "1001111";
	FOUR     <= not "1100110";
	FIVE     <= not "1101101";
	SIX      <= not "1111101";
	SEVEN    <= not "0000111";
	EIGHT    <= not "1111111";
	NINE     <= not "1101111";
	TEN      <= not "1110111";
	ELEVEN   <= not "1111100";
	TWELVE   <= not "0111001";
	THIRTEEN <= not "1011110";
	FOURTEEN <= not "1111001";
	FIFTEEN  <= not "1110001";
	DASH	 <= not "1000000";
	BLANK	 <= not "0000000";

	RippleBlank_Out <= blank_out;
	 --digit is zero
	isZero_vector <= code XNOR "0000";
	isZero <= isZero_vector(3) AND isZero_vector(2) AND isZero_vector(1) AND isZero_vector(0);
	blank_out <= RippleBlank_In AND isZero; --blank when this is true
	blank_code <= blank_out&code;
	
	with blank_code select
		segments <= 			ZERO 	 when "00000",
								ONE  	 when "00001",
								TWO      when "00010",
								THREE    when "00011",
								FOUR     when "00100",
								FIVE     when "00101",
								SIX      when "00110",
								SEVEN    when "00111",
								EIGHT    when "01000",
								NINE     when "01001",
								TEN      when "01010",
								ELEVEN   when "01011",
								TWELVE   when "01100",
								THIRTEEN when "01101",
								FOURTEEN when "01110",
								FIFTEEN  when "01111",
								BLANK    when "10000",
								ONE  	 when "10001", 
                                TWO      when "10010",
                                THREE    when "10011",
                                FOUR     when "10100",
                                FIVE     when "10101",
                                SIX      when "10110",
                                SEVEN    when "10111",
                                EIGHT    when "11000",
                                NINE     when "11001",
                                TEN      when "11010",
                                ELEVEN   when "11011",
                                TWELVE   when "11100",
                                THIRTEEN when "11101",
                                FOURTEEN when "11110",
                                FIFTEEN  when "11111",
								DASH	 when OTHERS;
								
end behv;
								