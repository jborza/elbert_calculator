-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY keypad_decoder_test IS
  END keypad_decoder_test;

  ARCHITECTURE behavior OF keypad_decoder_test IS 

  -- Component Declaration
	
	COMPONENT keypad_decoder
	PORT(
		clk : IN std_logic;
		row_pins : IN std_logic_vector(3 downto 0);
		column_pins : IN std_logic_vector(3 downto 0);
		reset : IN std_logic;          
		keycode_output : OUT std_logic_vector(3 downto 0);
		is_key_pressed : OUT std_logic
		);
	END COMPONENT;
		
		-- inputs
		SIGNAL clk : std_logic := '0';
		SIGNAL row_pins : std_logic_vector(3 downto 0) := (others => '0');
		SIGNAL column_pins : std_logic_vector(3 downto 0) := (others => '0');
		SIGNAL reset : std_logic := '0';          
		
		-- outputs
		SIGNAL keycode_output : std_logic_vector(3 downto 0);
		SIGNAL is_key_pressed : std_logic;
          

	   constant clk_period : time := 10 ns;

  BEGIN

  -- Component Instantiation
    uut: keypad_decoder  PORT MAP(
		clk => Clk,
		row_pins => row_pins,
		column_pins => column_pins,
		keycode_output => keycode_output,
		is_key_pressed => is_key_pressed,
		reset => reset
	);

  -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	  -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		column_pins <= "1000";
		row_pins <= "1000";
		wait for clk_period;
		
		wait for clk_period;
		
	 wait;
   end process;
  END;
