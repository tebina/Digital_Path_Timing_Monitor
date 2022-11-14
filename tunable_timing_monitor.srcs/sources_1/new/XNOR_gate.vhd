library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity XNOR_gate is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           output : out STD_LOGIC);
end XNOR_gate;

architecture Behavioral of XNOR_gate is

begin

output <= not (A xor B);

end Behavioral;
