library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity num_ones_for is
    generic (counter_size : integer := 16;
            input_vector_size : integer := 64);
    Port ( A : in  STD_LOGIC_VECTOR (input_vector_size-1 downto 0);
           ones : out  STD_LOGIC_VECTOR (counter_size-1 downto 0));
end num_ones_for;

architecture Behavioral of num_ones_for is
constant zeros_vector : unsigned (counter_size-2 downto 0) := (others => '0');

begin

process(A)
variable count : unsigned(counter_size-1 downto 0) := (others => '0');

begin
    count := (others => '0');   --initialize count variable.
    for i in 0 to input_vector_size-1 loop   --for all the bits.
        count := count + (zeros_vector & A(i));   --Add the bit to the count.
    end loop;
    ones <= std_logic_vector(count);    --assign the count to output.
end process;

end Behavioral;