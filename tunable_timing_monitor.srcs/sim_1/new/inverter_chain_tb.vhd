----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/02/2022 02:27:26 PM
-- Design Name: 
-- Module Name: inverter_chain_tb - Behavioral
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


entity inverter_chain_tb is
end inverter_chain_tb;

architecture Behavioral of inverter_chain_tb is

component inverter_chain is

    generic(chain_lenght : integer := 10001);
    
    Port ( input : in STD_LOGIC;
           output : out STD_LOGIC);
    
end component;

signal input : std_logic ;
signal output : std_logic ;

begin

uut : inverter_chain 
port map ( input => input , output => output );

input <= '0', '1' after 50 ns ;

end Behavioral;
