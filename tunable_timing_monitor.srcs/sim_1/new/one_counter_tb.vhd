----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/10/2022 12:35:02 PM
-- Design Name: 
-- Module Name: one_counter_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity one_counter_tb is
--  Port ( );
end one_counter_tb;

architecture Behavioral of one_counter_tb is

component num_ones_for is
    generic (counter_size : integer := 16;
            input_vector_size : integer := 64);
    Port ( A : in  STD_LOGIC_VECTOR (input_vector_size-1 downto 0);
           ones : out  STD_LOGIC_VECTOR (counter_size-1 downto 0));
end component;
signal A : STD_LOGIC_VECTOR (64-1 downto 0);
signal ones : STD_LOGIC_VECTOR (16-1 downto 0);
begin

counter : num_ones_for port map ( A => A , ones => ones );

A <= "0000000000100000001000000000000000000000000100001000000000001000";

end Behavioral;
