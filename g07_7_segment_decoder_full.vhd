-- this circuit implements a 4 digit, 7 segment decoder
--
-- entity name: g07_7_segment_decoder_full
--
-- Copyright (C) 2014 Jacob Barnett and Alex Bhandari-Young
-- Version 1.0
-- Authors: Jacob Barnett (jacob.barnet@mail.mcgill.ca) and Alex Bhandari-Young (alex.bhandari@mail.mcgill.ca)
-- Date: October 9, 2014
library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;

entity g07_7_segment_decoder_full is
port ( BCD1, BCD2, BCD3, BCD4  : in std_logic_vector(3 downto 0);
	   seg1,seg2,seg3,seg4     : out std_logic_vector(6 downto 0));
end g07_7_segment_decoder_full;

architecture behv of g07_7_segment_decoder_full is

	component g07_7_segment_decoder is
		port (	code : in std_logic_vector(3 downto 0);
				RippleBlank_In : in std_logic;
				RippleBlank_Out : out std_logic;
				segments : out std_logic_vector(6 downto 0));
	end component;
	
signal r1,r2,r3,r4,NOTHING : std_logic;

begin

	r4 <= '1';

	i4 : g07_7_segment_decoder port map( code => BCD4, RippleBlank_In => r4, RippleBlank_Out => r3, segments => seg4);
	i3 : g07_7_segment_decoder port map( code => BCD3, RippleBlank_In => r3, RippleBlank_Out => r2, segments => seg3);
	i2 : g07_7_segment_decoder port map( code => BCD2, RippleBlank_In => r2, RippleBlank_Out => r1, segments => seg2);
	i1 : g07_7_segment_decoder port map( code => BCD1, RippleBlank_In => r1, RippleBlank_Out => NOTHING, segments => seg1);

end behv;