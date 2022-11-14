library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity edge_detect is
    generic ( tdc_size : integer := 8 ;
              counter_size : integer := 8); 
    port ( reference_edge : in std_logic;
           expected_edge : in std_logic;
           clk : in std_logic; 
           slack : out std_logic_vector (tdc_size-1 downto 0);
           ones_count : out std_logic_vector (counter_size-1 downto 0));
end edge_detect;

architecture Behavioral of edge_detect is

component edge_detect_cell is
  Port ( B : in std_logic;
         A : in std_logic;
        clk : in std_logic;  
        inv_out : out std_logic;
        xor_out : out std_logic);
end component;

component negative_edge_detect_cell is
  Port ( B : in std_logic;
         A : in std_logic;
        clk : in std_logic;  
        inv_out : out std_logic;
        xnor_out : out std_logic);
end component;

component num_ones_for is
    generic (counter_size : integer := 8;
            input_vector_size : integer := 8);
    Port ( A : in  STD_LOGIC_VECTOR (input_vector_size-1 downto 0);
           ones : out  STD_LOGIC_VECTOR (counter_size-1 downto 0));
end component ;

signal c : std_logic_vector (tdc_size downto 0);
signal slack_signal : std_logic_vector (tdc_size-1 downto 0);

begin

neg_pos_cell : for i in 0 to tdc_size/2-2  generate
        pos_cell : edge_detect_cell port map (c(i*2) , expected_edge , clk , c(i*2+1) , slack_signal(i*2+1)); --even
        neg_cell : negative_edge_detect_cell port map(c(i*2+1) , expected_edge , clk , c(i*2+2) , slack_signal(i*2+2)); --odd 
end generate;

firstcell: negative_edge_detect_cell port map (reference_edge , expected_edge , clk , c(0) , slack_signal (0));
lastcell : edge_detect_cell port map (c(tdc_size-2), expected_edge , clk , c(tdc_size-2+1), slack_signal(tdc_size - 1 ));

slack <= slack_signal ; 

count_ones : num_ones_for
generic map (counter_size => 8 , input_vector_size => 8)
port map (A => slack_signal , ones => ones_count);


end Behavioral;
