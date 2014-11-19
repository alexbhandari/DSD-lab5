-- This circuit implements the ADD3 function, where the output Y is equal to
-- the input X as long as X is less than 5, otherwise it is equal to X+3
-- The circuit will be used in a binary to BCD converter, hence the X values
-- will be assumed to have values from 0000 to 1001. The output for values other
-- than these are don’t cares.
--
-- entity name: g00_ADD3
--
-- Copyright (C) 2014 James Clark
-- Version 1.0
-- Author: James J. Clark; james.j.clark@mcgill.ca
-- Date: September 21, 2014
library ieee; 
use ieee.std_logic_1164.all; -- allows use of the std_logic_vector type

entity g07_ADD3 is
	port ( x4,x3,x2,x1  : in  std_logic;
		   y4,y3,y2,y1 : out std_logic );
end g07_ADD3;

architecture behv of g07_ADD3 is

signal input  : std_logic_vector(3 downto 0);
signal output : std_logic_vector(3 downto 0);

begin

input <= (x4&x3&x2&x1);
y4 <= output(3);
y3 <= output(2);
y2 <= output(1);
y1 <= output(0);

	with input select
		output <=   input         when "0000",
					input         when "0001",
					input         when "0010",
					input         when "0011",
					input         when "0100",
					"1000"        when "0101",
					"1001"        when "0110",
					"1010"        when "0111",
					"1011"        when "1000",
					"1100"        when "1001",
					"0000"        when OTHERS;
end behv;
					