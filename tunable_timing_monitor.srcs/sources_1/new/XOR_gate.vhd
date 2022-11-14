library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity XOR_gate is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           output : out STD_LOGIC);
end XOR_gate;

architecture Behavioral of XOR_gate is

begin

output <= A xor B ;

end Behavioral;
