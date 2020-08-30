----------------------------------------------------------------------------------
-- keypad debouncer - must stay stable for N clocks
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity keypad_debounce is
    Port ( clk : in  STD_LOGIC;
           key_pressed_in : in  STD_LOGIC_VECTOR (3 downto 0);
           key_pressed_debounced : out  STD_LOGIC_VECTOR (3 downto 0));
end keypad_debounce;

architecture Behavioral of keypad_debounce is

begin
	process(clk) 
		constant DEBOUNCE_CLK_PERIODS : integer := 16;
		variable next_keypad_state : STD_LOGIC_VECTOR(3 downto 0) := "0000";
		variable debounce_count : integer range 0 to DEBOUNCE_CLK_PERIODS-1 := 0;
	begin
		if rising_edge(clk) then
			if (key_pressed_in /= next_keypad_state) then
			next_keypad_state := key_pressed_in;
			debounce_count := 0;
		else
      if (debounce_count /= DEBOUNCE_CLK_PERIODS-1) then
        debounce_count := debounce_count + 1;
      else
        key_pressed_debounced <= next_keypad_state;
      end if;
    end if;
		end if;
	end process;

end Behavioral;

