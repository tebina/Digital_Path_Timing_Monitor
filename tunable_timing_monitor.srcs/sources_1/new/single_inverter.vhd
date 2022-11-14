----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/02/2022 12:11:21 PM
-- Design Name: 
-- Module Name: single_inverter - Behavioral
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


entity single_inverter is
    Port ( inv_input : in STD_LOGIC;
           inv_output : out STD_LOGIC);
end single_inverter;

architecture Behavioral of single_inverter is

begin

inv_output <= not inv_input;

end Behavioral;
