----------------------------------------------------------------------------------
-- converts an N-digit BCD number to binary
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.all;

entity bcd_to_binary_gen_converter is
	generic (N : integer := 3);
   Port ( number_bcd : in  STD_LOGIC_VECTOR ((N*4)-1 downto 0);
          number_binary : out  STD_LOGIC_VECTOR (natural(ceil(log2(10 ** real(N))))-1 downto 0)); --would be 10 for 3 digits
end bcd_to_binary_gen_converter;

architecture Behavioral of bcd_to_binary_gen_converter is
	
begin
	gen_bcd: for I in 0 to N generate
	
	end generate gen_bcd;

end Behavioral;