----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity calc_top_module is
	Port ( Clk : in STD_LOGIC;
				--DPSwitch : in  STD_LOGIC_VECTOR (7 downto 0);
           SevenSegment : out  STD_LOGIC_VECTOR (7 downto 0);
			  --Enable : out STD_LOGIC_VECTOR(2 downto 0);
			  IO_P4_ROW : in STD_LOGIC_VECTOR(3 downto 0);
			  IO_P4_COL : out STD_LOGIC_VECTOR(3 downto 0);
			  LED : out STD_LOGIC_VECTOR(7 downto 0)
			  ); --7-segment enable bits
end calc_top_module;

architecture Behavioral of calc_top_module is
	COMPONENT keypad
	PORT(
		Clk : IN std_logic;
		RowPins : IN std_logic_vector(3 downto 0);
		Reset : IN std_logic;          
		ColumnPins : OUT std_logic_vector(3 downto 0);
		Output : OUT std_logic_vector(3 downto 0);
		OutputReady : OUT std_logic
		);
	END COMPONENT;
	
	signal OutputReady : STD_LOGIC;
begin

	Inst_keypad: keypad PORT MAP(
		Clk => Clk,
		RowPins => IO_P4_ROW,
		ColumnPins => IO_P4_COL,
		Output => LED(3 downto 0),
		OutputReady => OutputReady,
		Reset => '0'
	);

process(Clk)
begin
		if rising_edge(Clk) then
			--LED <= IO_P4;
			--SevenSegment <= IO_P4;
		end if;
end process;

end Behavioral;

