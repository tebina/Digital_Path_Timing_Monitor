library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity AXI_LITE_WRAPPER is

  generic (
    ADRWIDTH  : integer := 8;
    DATAWIDTH : integer := 32
    );
  port (
    -- AXI SLAVE INTERFACE ----------------------------
    -- Clock and Reset
    S_AXI_ACLK    : in  std_logic;
    S_AXI_ARESETN : in  std_logic;
    -- Write Address Channel
    S_AXI_AWADDR  : in  std_logic_vector(ADRWIDTH - 1 downto 0);
    S_AXI_AWVALID : in  std_logic;
    S_AXI_AWREADY : out std_logic;
    -- Write Data Channel
    S_AXI_WDATA   : in  std_logic_vector(DATAWIDTH - 1 downto 0);
    S_AXI_WSTRB   : in  std_logic_vector(3 downto 0);
    S_AXI_WVALID  : in  std_logic;
    S_AXI_WREADY  : out std_logic;
    -- Read Address Channel
    S_AXI_ARADDR  : in  std_logic_vector(ADRWIDTH - 1 downto 0);
    S_AXI_ARVALID : in  std_logic;
    S_AXI_ARREADY : out std_logic;
    -- Read Data Channel
    S_AXI_RDATA   : out std_logic_vector(DATAWIDTH - 1 downto 0);
    S_AXI_RRESP   : out std_logic_vector(1 downto 0);
    S_AXI_RVALID  : out std_logic;
    S_AXI_RREADY  : in  std_logic;
    -- Write Response Channel
    S_AXI_BRESP   : out std_logic_vector(1 downto 0);
    S_AXI_BVALID  : out std_logic;
    S_AXI_BREADY  : in  std_logic
    );
end entity;

architecture behavioral of AXI_LITE_WRAPPER is

component edge_detect is
    generic ( tdc_size : integer := 64 ); 
    port ( reference_edge : in std_logic;
           expected_edge : in std_logic;
           clk : in std_logic; 
           slack : out std_logic_vector (tdc_size-1 downto 0));
end component; 

constant tdc_size : integer := 64 ; 
signal reference_edge :std_logic ;
signal expected_edge :std_logic ;
signal slack : std_logic_vector (tdc_size-1 downto 0);
signal Axi_slave_reg : std_logic_vector (DATAWIDTH - 1 downto 0);




begin

wrapper : edge_detect port map (reference_edge => reference_edge , expected_edge => expected_edge , clk => S_AXI_ACLK, slack => slack );

read_process : process (S_AXI_ACLK)
begin
    if rising_edge(S_AXI_ACLK) then
    S_AXI_RDATA <= (others => '0');
    S_AXI_RVALID <= '0';
    if S_AXI_ARVALID = '1' and S_AXI_RREADY = '1' and S_AXI_ARESETN = '0' then 
        S_AXI_ARREADY <= '1' ;
        case S_AXI_ARADDR is 
            when "00000001" => --slack [31:0]
            S_AXI_RDATA <= slack(31 downto 0);
            S_AXI_RVALID <= '1';
            S_AXI_RRESP <= "00";
            when "00000010" => --slack [63:32]
            S_AXI_RDATA <= slack(63 downto 32);
            S_AXI_RVALID <= '1';
            S_AXI_RRESP <= "00";
            when "00000000" => --slack [63:32]
            S_AXI_RDATA <= "11011110101011011011111011101111";
            S_AXI_RVALID <= '1';
            S_AXI_RRESP <= "00";  
            when others => null;
        end case;
    end if;
    end if;
end process; 

write_process : process (S_AXI_ACLK)
begin
    if rising_edge(S_AXI_ACLK) then
    S_AXI_BVALID <= '0';
    S_AXI_BRESP <= "00";
    if S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and S_AXI_ARESETN = '0' then 
        S_AXI_AWREADY <= '1' ;
        S_AXI_WREADY <= '1' ;
        if S_AXI_BREADY = '1' then
            S_AXI_BVALID <= '1';
            case S_AXI_AWADDR is 
                when "00000000" => 
                reference_edge <= Axi_slave_reg (0);
                S_AXI_BRESP <= "00";
                when "00000001" =>
                expected_edge <= Axi_slave_reg (0);
                S_AXI_BRESP <= "00";
                when others => null;
            end case;
        end if;
    end if;
    end if;
end process; 


Axi_slave_reg <= S_AXI_WDATA ; 


end Behavioral;
