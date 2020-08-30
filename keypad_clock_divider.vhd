----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;


entity keypad_clock_divider is
    Port ( clk : in  STD_LOGIC; -- 12 MHz clock
           clk_slow : out  STD_LOGIC); --12,000,000 Hz / 8,192 = 1464 Hz
end keypad_clock_divider;

architecture Behavioral of keypad_clock_divider is
signal clk_refresh_counter : unsigned (12 downto 0); --13-bit counter (8192)
begin
process(clk)
begin
	if rising_edge(clk) then
		clk_refresh_counter <= clk_refresh_counter + 1;
		if(clk_refresh_counter = 0) then
			clk_slow <= '1';
		else
			clk_slow <= '0';
		end if;
	end if;
end process;

end Behavioral;

