----------------------------------------------------------------------------------
-- converts 3-digit BCD number to binary
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.all;


entity bcd_to_binary_converter is
   Port ( Clk : in STD_LOGIC;
			 number_bcd : in  STD_LOGIC_VECTOR (11 downto 0); --12 bits for 3 digits
          number_binary : out  STD_LOGIC_VECTOR (9 downto 0)); --(natural(ceil(log2(10 ** real(N))))-1 downto 0)); --would be 10 for 
end bcd_to_binary_converter;

architecture Behavioral of bcd_to_binary_converter is
signal digit_0 : unsigned(9 downto 0);
signal digit_1 : unsigned(9 downto 0);
signal digit_2 : unsigned(9 downto 0);
begin
		with number_bcd(3 downto 0) select
			digit_0 <= 
				to_unsigned(0,digit_0'length) when "0000",
				to_unsigned(1,digit_0'length) when "0001",
				to_unsigned(2,digit_0'length) when "0010",
				to_unsigned(3,digit_0'length) when "0011",
				to_unsigned(4,digit_0'length) when "0100",
				to_unsigned(5,digit_0'length) when "0101",
				to_unsigned(6,digit_0'length) when "0110",
				to_unsigned(7,digit_0'length) when "0111",
				to_unsigned(8,digit_0'length) when "1000",			
				to_unsigned(9,digit_0'length) when others;
		with number_bcd(7 downto 4) select
			digit_1 <= 
				to_unsigned(0 ,digit_1'length) when "0000",
				to_unsigned(10,digit_1'length) when "0001",
				to_unsigned(20,digit_1'length) when "0010",
				to_unsigned(30,digit_1'length) when "0011",
				to_unsigned(40,digit_1'length) when "0100",
				to_unsigned(50,digit_1'length) when "0101",
				to_unsigned(60,digit_1'length) when "0110",
				to_unsigned(70,digit_1'length) when "0111",
				to_unsigned(80,digit_1'length) when "1000",			
				to_unsigned(90,digit_1'length) when others;
		with number_bcd(11 downto 8) select
			digit_2 <= 
				to_unsigned(0,  digit_2'length) when "0000",
				to_unsigned(100,digit_2'length) when "0001",
				to_unsigned(200,digit_2'length) when "0010",
				to_unsigned(300,digit_2'length) when "0011",
				to_unsigned(400,digit_2'length) when "0100",
				to_unsigned(500,digit_2'length) when "0101",
				to_unsigned(600,digit_2'length) when "0110",
				to_unsigned(700,digit_2'length) when "0111",
				to_unsigned(800,digit_2'length) when "1000",			
				to_unsigned(900,digit_2'length) when others;
		number_binary <= std_logic_vector(digit_0 + digit_1 + digit_2);
		
end Behavioral;