--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   07:41:09 08/13/2020
-- Design Name:   
-- Module Name:   E:/projects/fpga/elbert_calculator/bcd_to_binary_converter_test.vhd
-- Project Name:  elbert_calculator
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: bcd_to_binary_converter
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
USE ieee.numeric_std.ALL;
 
ENTITY bcd_to_binary_converter_test IS
END bcd_to_binary_converter_test;
 
ARCHITECTURE behavior OF bcd_to_binary_converter_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT bcd_to_binary_converter
    PORT(
         Clk : IN  std_logic;
         number_bcd : IN  std_logic_vector(11 downto 0);
         number_binary : OUT  std_logic_vector(9 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal number_bcd : std_logic_vector(11 downto 0) := (others => '0');

 	--Outputs
   signal number_binary : std_logic_vector(9 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: bcd_to_binary_converter PORT MAP (
          Clk => Clk,
          number_bcd => number_bcd,
          number_binary => number_binary
        );

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for Clk_period;

      -- insert stimulus here 
		number_bcd <= "000000000000";
		wait for Clk_period;
		number_bcd <= "000000000001";
		wait for Clk_period;
		number_bcd <= "000000000010";
		wait for Clk_period;
		number_bcd <= "000000000011";
		wait for Clk_period;
		number_bcd <= "000000000100";
		wait for Clk_period;
		--005
		number_bcd <= "000000000101";
		wait for Clk_period;
		--010
		number_bcd <= "000000010000";
		wait for Clk_period;
		--100
		number_bcd <= "000100000000";
		wait for Clk_period;
		--012
		number_bcd <= "000100000010";
		wait for Clk_period;
		--123
		number_bcd <= "000100100011";
		wait for Clk_period;
		--304
		number_bcd <= "001100000100";
		wait for Clk_period;
		--987
		number_bcd <= "100110000111";
		wait for Clk_period;
   end process;

END;
