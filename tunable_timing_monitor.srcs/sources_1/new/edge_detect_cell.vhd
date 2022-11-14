library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity edge_detect_cell is
  Port ( B : in std_logic;
         A : in std_logic;
        clk : in std_logic;  
        inv_out : out std_logic;
        xor_out : out std_logic);
        attribute dont_touch : string;
        attribute dont_touch of edge_detect_cell : entity is "true";       
end edge_detect_cell;

architecture Behavioral of edge_detect_cell is

component single_inverter is
    Port ( inv_input : in STD_LOGIC;
           inv_output : out STD_LOGIC);
end component ;

component RisingEdge_DFlipFlop is 
   port(
      Q : out std_logic;    
      Clk :in std_logic;   
      D :in  std_logic);
end component;

component  XOR_gate is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           output : out STD_LOGIC);
end component;

signal interB : std_logic ;
signal interA : std_logic ;

begin

inverter : single_inverter port map (inv_input => B, inv_output => interB);
dff : RisingEdge_DFlipFlop port map (D => interB , Clk => clk , Q => interA);
xor_output : XOR_gate port map (A => A , B => interA , output => xor_out);

inv_out <= interB ;

end Behavioral;
