--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:36:51 08/30/2020
-- Design Name:   
-- Module Name:   E:/projects/fpga/elbert_calculator/keypad_debounce_test.vhd
-- Project Name:  elbert_calculator
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: keypad_debounce
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY keypad_debounce_test IS
END keypad_debounce_test;
 
ARCHITECTURE behavior OF keypad_debounce_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT keypad_debounce
    PORT(
         clk : IN  std_logic;
         key_pressed_in : IN  std_logic_vector(3 downto 0);
         key_pressed_debounced : OUT  std_logic_vector(3 downto 0);
			output_stable : OUT std_logic;
			reset : IN std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
	signal reset : std_logic := '1';
   signal key_pressed_in : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal key_pressed_debounced : std_logic_vector(3 downto 0);
	signal output_stable : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: keypad_debounce PORT MAP (
          clk => clk,
          key_pressed_in => key_pressed_in,
          key_pressed_debounced => key_pressed_debounced,
			 output_stable => output_stable,
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
		reset <= '1';
      wait for 100 ns;	

      --wait for clk_period*10;
		reset <= '0';

      -- insert stimulus here 
		key_pressed_in <= "0101";
		wait for clk_period;
		key_pressed_in <= "0111";
		wait for clk_period;
		key_pressed_in <= "0101";
		wait for clk_period;
		key_pressed_in <= "0000";
		wait for clk_period;
		key_pressed_in <= "1000";
		wait for clk_period*6;
		key_pressed_in <= "1111";
		wait for clk_period*10;
		key_pressed_in <= "0001";
		wait for clk_period*10;
		--try the whole thing again
		key_pressed_in <= "0101";
		wait for clk_period;
		key_pressed_in <= "0111";
		wait for clk_period*2;
		key_pressed_in <= "0101";
		wait for clk_period*3;
		key_pressed_in <= "0000";
		wait for clk_period;
		key_pressed_in <= "1000";
		wait for clk_period*6;
		key_pressed_in <= "1111";
		wait for clk_period*10;
      wait;
   end process;

END;
