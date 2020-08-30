library IEEE;
use IEEE.STD_LOGIC_1164.all;

package functions_package is


function  pow10 (X : in INTEGER) return INTEGER;
end functions_package;

package body functions_package is

function pow10 (X : in INTEGER) return INTEGER is
variable result : integer;
begin
	result := 1;
	for i in 0 to X loop
		result := result * 10;
	end loop;
	return result;
end function pow10;

end functions_package;
