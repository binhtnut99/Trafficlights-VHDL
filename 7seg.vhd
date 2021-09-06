library IEEE;                                                                                      --
use IEEE.STD_LOGIC_1164.ALL;                                                                       --
use IEEE.NUMERIC_STD.ALL;                                                                          --
																								   -- code giải mã hiển thị led 7 thanh
entity Seven_segment is                                                                            --
	port                                                                                           --
	(                                                                                              --
		clock			: in std_logic;                                                            -- 
		bcd_1, bcd_11, bcd_2, bcd_22, bcd_3, bcd_33 : in unsigned(3 downto 0);                     -- tín hiệu đưa về giải mã
		to_LED 			: out unsigned(6 downto 0);                                                --
		Selected_digit 	: out unsigned(5 downto 0);                                                --
		Dot 			: out std_logic                                                            --
	);                                                                                             --
																								   --
end Seven_segment;                                                                                 --
																								   --
architecture Behavioral of Seven_segment is                                                        --
	signal	BCD_input 			: unsigned(3 downto 0) := "0000";                                  --
	signal	Selected_digit_int 	: unsigned(5 downto 0) := "111110";                                --
	signal	cntr	 			: integer range 0 to 10000 := 0;                                   --
																								   --
begin                                                                                              --
	Selected_digit <= Selected_digit_int;                                                          --
	-------------------------------------                                                          --
	process(clock)                                                                                 --
	begin                                                                                          --
		if rising_edge(clock) then                                                                 --
			cntr <= cntr + 1;                                                                      --
			-- sweep between 6 7segments:                                                          --
			if (cntr = 10000) then -- every 2msec                                                  --
				cntr <= 0;                                                                         --
				Selected_digit_int <= Selected_digit_int(0) & Selected_digit_int(5 downto 1);      --
			end if;                                                                                --
		end if;                                                                                    --
	end process;                                                                                   -- chương trình quét led
	-------------------------------                                                                --
	Dot <= ( Selected_digit_int(2) and Selected_digit_int(4));                                     --
																								   --
	------------------------                                                                       --
	with BCD_input select                                                                          -- chương trình giải mã
	to_LED <= 	"0000001" when "0000",  -- 0                                                       --
				"1001111" when "0001",  -- 1                                                       --
				"0010010" when "0010",	-- 2			                                           --
				"0000110" when "0011",	-- 3			                                           --
				"1001100" when "0100",	-- 4			                                           --
				"0100100" when "0101",	-- 5			                                           --
				"0100000" when "0110",	-- 6			                                           --
				"0001111" when "0111",	-- 7			                                           --
				"0000000" when "1000",	-- 8			                                           --
				"0000100" when "1001",	-- 9			                                           --
																								   --
				"1111110" when others;                                                             --
	-----------------------                                                                        --
	with Selected_digit_int select                                                                 -- chương trình quét led
	BCD_input <= bcd_1	when "111110",                                                             --
				 bcd_11	when "111101",                                                             --
				 bcd_2	when "111011",                                                             --
				 bcd_22	when "110111",                                                             --
				 bcd_3	when "101111",                                                             --
				 bcd_33	when "011111",                                                             --
				 "0000" when others;                                                               --
																								   --
end Behavioral;