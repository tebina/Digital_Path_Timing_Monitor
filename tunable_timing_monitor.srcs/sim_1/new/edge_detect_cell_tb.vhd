library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edge_detect_cell_tb is
end edge_detect_cell_tb;

architecture Behavioral of edge_detect_cell_tb is


component edge_detect_cell is
  Port ( B : in std_logic;
         A : in std_logic;
        clk : in std_logic;  
        inv_out : out std_logic;
        xor_out : out std_logic);
end component;

  -- Procedure for clock generation
  procedure clk_gen(signal clk : out std_logic; constant FREQ : real; constant time_delay : time) is
    constant PERIOD    : time := 1 sec / FREQ;        -- Full period
    constant HIGH_TIME : time := PERIOD / 2;          -- High time
    constant LOW_TIME  : time := PERIOD - HIGH_TIME;  -- Low time; always >= HIGH_TIME
  begin
    -- Check the arguments
    assert (HIGH_TIME /= 0 fs) report "clk_plain: High time is zero; time resolution to large for frequency" severity FAILURE;
    -- Generate a clock cycle
    loop
      clk <= '1';
      wait for HIGH_TIME + time_delay;
      clk <= '0';
      wait for LOW_TIME;
    end loop;
  end procedure;

  -- Clock frequency and signal
  signal clk_250 : std_logic;
  signal clk_50 : std_logic;
  signal delayed_clk_50 : std_logic;

  -- Component signals
  signal B : std_logic;
  signal A : std_logic;
  signal clk : std_logic;  
  signal inv_out : std_logic;
  signal xor_out : std_logic;

begin

uut : edge_detect_cell 
port map ( B => B , A => A , clk => clk , inv_out => inv_out , xor_out => xor_out );

  -- Clock generation with concurrent procedure call
clk_gen(clk_250, 250.000E6,0 ns);  -- 250.000 MHz clock
clk_gen(clk_50, 50.000E6,0 ns);  -- 50.000 MHz clock
clk_gen(delayed_clk_50, 50.000E6,5 ns);  -- 50.000 MHz clock

A <= clk_50;
B <= delayed_clk_50;
clk <= clk_250;

end Behavioral;
