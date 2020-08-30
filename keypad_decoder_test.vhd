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
        -- hold reset state 
        wait for 10 ns;	

        -- insert stimulus here 		
        column_pins <= "0001";
        row_pins <= "0001";		
        wait for clk_period*4;
        assert (is_key_pressed='1') report "is_key_pressed should be 1" severity failure;
        assert (keycode_output=x"1") report "output should be 1" severity failure;

        column_pins <= "0001";
        row_pins <= "0010";		
        wait for clk_period*4;
        assert (is_key_pressed='1') report "is_key_pressed should be 1" severity failure;
        assert (keycode_output=x"4") report "output should be 4" severity failure;

        column_pins <= "0001";
        row_pins <= "0100";		
        wait for clk_period*4;
        assert (is_key_pressed='1') report "is_key_pressed should be 1" severity failure;
        assert (keycode_output=x"7") report "output should be 4" severity failure;

        column_pins <= "0001";
        row_pins <= "1000";		
        wait for clk_period*4;
        assert (is_key_pressed='1') report "is_key_pressed should be 1" severity failure;
        assert (keycode_output=x"e") report "output should be 4" severity failure;

        column_pins <= "0010";
        row_pins <= "0000";		
        wait for clk_period * 4;
        assert (is_key_pressed='0') report "is_key_pressed should be 0" severity failure;
        assert (keycode_output=x"0") report "output should be 0" severity failure;

        column_pins <= "0010";
        row_pins <= "1000";		
        wait for clk_period*4;
        assert (is_key_pressed='1') report "is_key_pressed should be 1" severity failure;
        assert (keycode_output=x"0") report "output should be 0" severity failure;

        column_pins <= "0010";
        row_pins <= "0100";		
        wait for clk_period*4;
        assert (is_key_pressed='1') report "is_key_pressed should be 1" severity failure;
        assert (keycode_output=x"8") report "output should be 8" severity failure;

        column_pins <= "0010";
        row_pins <= "0010";		
        wait for clk_period*4;
        assert (is_key_pressed='1') report "is_key_pressed should be 1" severity failure;
        assert (keycode_output=x"5") report "output should be 5" severity failure;

        column_pins <= "0010";
        row_pins <= "0001";		
        wait for clk_period*4;
        assert (is_key_pressed='1') report "is_key_pressed should be 1" severity failure;
        assert (keycode_output=x"2") report "output should be 2" severity failure;


        column_pins <= "0010";
        row_pins <= "0000";		
        wait for clk_period*4;
        assert (is_key_pressed='0') report "is_key_pressed should be 1" severity failure;
        assert (keycode_output=x"0") report "output should be 0" severity failure;

        assert false report "Test done." severity note;
	    wait;
   end process;
  END;
