library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edge_detect_tb is
end edge_detect_tb;

architecture Behavioral of edge_detect_tb is


component edge_detect is
--    generic ( tdc_size : integer := 64 ;
  --            counter_size : integer := 16); 
    port ( reference_edge : in std_logic;
           expected_edge : in std_logic;
           clk : in std_logic; 
           slack : out std_logic_vector (7 downto 0);
           ones_count : out std_logic_vector (8-1 downto 0));
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
  --signal clk_50 : std_logic;
  --signal delayed_clk_50 : std_logic;

  -- Component signals
  signal reference_edge : std_logic;
  signal expected_edge : std_logic;
--  signal clk : std_logic;  
  signal slack : std_logic_vector (7 downto 0);
  signal ones_count : std_logic_vector (7 downto 0);


begin

uut : edge_detect 
port map ( reference_edge => reference_edge , expected_edge => expected_edge , clk => clk_250  , slack => slack ,ones_count => ones_count);

  -- Clock generation with concurrent procedure call
clk_gen(clk_250, 250.000E6,0 ns);  -- 250.000 MHz clock
--clk_gen(clk_50, 50.000E6,0 ns);  -- 50.000 MHz clock
--clk_gen(delayed_clk_50, 50.000E6,5 ns);  -- 50.000 MHz clock

--stimuli : process 
--begin
--reference_edge <= '0' , '1' after 672.692 ns ;
--expected_edge <= '0', '1' after 500 ns ;
--end process;

stimuli : process 
    --variable delay : integer := 500 ; 
  begin
    for ii in 0 to 20 loop
        --delay := delay + ii ; 
        --reference_edge <= '0' , '1' after (delay*ii+10*ii) * 1ns ;
        --expected_edge <= '0', '1' after (delay*ii) * 1ns ;
        reference_edge <= '0';
        expected_edge <= '0';
        WAIT FOR (50) * 1ns ;
        expected_edge <= '1';
        WAIT FOR (50+ii) * 1ns ;
        reference_edge <= '1';
        WAIT FOR (50) * 1ns ;

    end loop;
    wait ;
end process;



end Behavioral;
