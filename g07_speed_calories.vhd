library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;
library lpm;
	use lpm.lpm_components.all;

entity g07_speed_calories is 
port ( clk : in std_logic;
	ROWER_POWER : in unsigned(3 downto 0);
	BOAT_SPEED, CALORIE_RATE : out unsigned(11 downto 0));
end g07_speed_calories;

architecture behv of g07_speed_calories is
	signal shifted_cubed_root_power_vector : std_logic_vector(11 downto 0);
	signal shifted_cubed_root_power, shifted_vconst : unsigned(11 downto 0);
	signal ROWER_POWER_vector : std_logic_vector(3 downto 0);
	signal full_CALORIE_RATE : unsigned(19 downto 0);
	signal full_BOAT_SPEED   : unsigned(23 downto 0);
	
begin

	shifted_cubed_root_power <= unsigned(shifted_cubed_root_power_vector);
	ROWER_POWER_vector <= std_logic_vector(ROWER_POWER);

--Calculate power in kilo-calories/hour [CALORIE_RATE=3.4416*power + 300]
	
	--fixed point multiplier:
		--value of power constant: 3.4416 decimal = 11.01110001000011001011001010010101111010011110000111 binary
		-- multiply
		process(clk) begin
			if(rising_edge(clk)) then
				full_CALORIE_RATE <= "1101110001000011" * ROWER_POWER + "100101100000000000"; --shifted by 9 -> xxx.xxxxxxxxx
			end if;
		end process;
		
--Calculate velocity [0.7095*(power^(1/3)]

	--cubed root of power
		crc_table : lpm_rom -- use the altera rom library macrocell
		GENERIC MAP(
			lpm_widthad => 4, -- sets the width of the ROM address bus
			lpm_numwords => 16, -- sets the words stored in the ROM
			lpm_outdata => "UNREGISTERED", -- no register on the output
			lpm_address_control => "REGISTERED", -- register on the input
			lpm_file => "crc_rom.mif", -- the ascii file containing the ROM data
			lpm_width => 12) -- the width of the word stored in each ROM location
		PORT MAP(inclock => clk, address => ROWER_POWER_vector, q => shifted_cubed_root_power_vector);
		
	--fixed point multiplier:
		--value of velocity constant: 0.7095 decimal = 0.1011010110100001110010101100000010000011000100100111 binary
		shifted_vconst <= "000101101011"; --shifted by 9
		
		full_BOAT_SPEED  <= (shifted_vconst*(shifted_cubed_root_power)); --shifted by 18
		
		process(clk) begin
			if(rising_edge(clk)) then
				BOAT_SPEED <= full_BOAT_SPEED(20 downto 9); --(3,9)
				CALORIE_RATE <= full_CALORIE_RATE(19 downto 8); --(11,1)
			end if;
		end process;
		
end behv;