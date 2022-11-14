


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


entity AXI_LITE_WRAPPER_TB is
--  Port ( );
end AXI_LITE_WRAPPER_TB ;

architecture Behavioral of AXI_LITE_WRAPPER_TB is

component AXI_LITE_WRAPPER is 

  generic (
    ADRWIDTH  : integer := 8;
    DATAWIDTH : integer := 32);

  port (
    ---------------------------------------------------------------------------
    -- AXI Interface
    ---------------------------------------------------------------------------
    -- Clock and Reset
    S_AXI_ACLK    : in  std_logic;
    S_AXI_ARESETN : in  std_logic;
    -- Write Address Channel
    S_AXI_AWADDR  : in  std_logic_vector(ADRWIDTH-1 downto 0);
    S_AXI_AWVALID : in  std_logic;
    S_AXI_AWREADY : out std_logic;
    -- Write Data Channel
    S_AXI_WDATA   : in  std_logic_vector(31 downto 0);
    S_AXI_WSTRB   : in  std_logic_vector(3 downto 0);
    S_AXI_WVALID  : in  std_logic;
    S_AXI_WREADY  : out std_logic;
    -- Read Address Channel
    S_AXI_ARADDR  : in  std_logic_vector(ADRWIDTH-1 downto 0);
    S_AXI_ARVALID : in  std_logic;
    S_AXI_ARREADY : out std_logic;
    -- Read Data Channel
    S_AXI_RDATA   : out std_logic_vector(31 downto 0);
    S_AXI_RRESP   : out std_logic_vector(1 downto 0);
    S_AXI_RVALID  : out std_logic;
    S_AXI_RREADY  : in  std_logic;
    -- Write Response Channel
    S_AXI_BRESP   : out std_logic_vector(1 downto 0);
    S_AXI_BVALID  : out std_logic;
    S_AXI_BREADY  : in  std_logic);
      
end component;


constant ADRWIDTH : integer := 8 ;
constant DATAWIDTH : integer := 32 ; 
constant clk_period : time := 1 ns;

signal  S_AXI_ACLK    :   std_logic :='0';
signal    S_AXI_ARESETN :   std_logic := '0';
    -- Write Address Channel signals
signal    S_AXI_AWADDR  :   std_logic_vector(ADRWIDTH-1 downto 0) :=(others => '0');
signal    S_AXI_AWVALID :   std_logic := '0';
signal    S_AXI_AWREADY :  std_logic ;
    -- Write Data Channel signals 
signal    S_AXI_WDATA   :   std_logic_vector(31 downto 0):= (others => '0');
signal    S_AXI_WSTRB   :   std_logic_vector(3 downto 0):= (others => '0');
signal    S_AXI_WVALID  :   std_logic :='0';
signal    S_AXI_WREADY  :  std_logic ;
    -- Read Address Channel signals 
signal    S_AXI_ARADDR  :   std_logic_vector(ADRWIDTH-1 downto 0):=(others=>'0');
signal    S_AXI_ARVALID :   std_logic:='0';
signal    S_AXI_ARREADY :  std_logic;
    -- Read Data Channel signals
signal    S_AXI_RDATA   :  std_logic_vector(31 downto 0) ;
signal    S_AXI_RRESP   :  std_logic_vector(1 downto 0);
signal    S_AXI_RVALID  :  std_logic;
signal    S_AXI_RREADY  :   std_logic :='0';
    -- Write Response Channel signals
signal    S_AXI_BRESP   :  std_logic_vector(1 downto 0);
signal    S_AXI_BVALID  :  std_logic;
signal    S_AXI_BREADY  :   std_logic := '0';

    Constant ClockPeriod : TIME := 5 ns;
    Constant ClockPeriod2 : TIME := 10 ns;
    shared variable ClockCount : integer range 0 to 50_000 := 10;
    signal sendIt : std_logic := '0';
    signal readIt : std_logic := '0';

begin
  UUT: AXI_LITE_WRAPPER
    
    port map (
      S_AXI_ACLK    => S_AXI_ACLK,
      S_AXI_ARESETN => S_AXI_ARESETN,
      S_AXI_AWADDR  => S_AXI_AWADDR,
      S_AXI_AWVALID => S_AXI_AWVALID,
      S_AXI_AWREADY => S_AXI_AWREADY,
      S_AXI_WDATA   => S_AXI_WDATA,
      S_AXI_WSTRB   => S_AXI_WSTRB,
      S_AXI_WVALID  => S_AXI_WVALID,
      S_AXI_WREADY  => S_AXI_WREADY,
      S_AXI_BRESP   => S_AXI_BRESP,
      S_AXI_BVALID  => S_AXI_BVALID,
      S_AXI_BREADY  => S_AXI_BREADY,
      S_AXI_ARADDR  => S_AXI_ARADDR,
      S_AXI_ARVALID => S_AXI_ARVALID,
      S_AXI_ARREADY => S_AXI_ARREADY,
      S_AXI_RDATA   => S_AXI_RDATA,
      S_AXI_RRESP   => S_AXI_RRESP,
      S_AXI_RVALID  => S_AXI_RVALID,
      S_AXI_RREADY  => S_AXI_RREADY);


 GENERATE_REFCLOCK : process
 begin
   wait for (ClockPeriod / 2);
   ClockCount:= ClockCount+1;
   S_AXI_ACLK <= '1';
   wait for (ClockPeriod / 2);
   S_AXI_ACLK <= '0';
 end process;

send : PROCESS
 BEGIN
    S_AXI_AWVALID<='0';
    S_AXI_WVALID<='0';
    S_AXI_BREADY<='0';
    loop
        wait until sendIt = '1';
        wait until S_AXI_ACLK= '0';
            S_AXI_AWVALID<='1';
            S_AXI_WVALID<='1';
        wait until (S_AXI_AWREADY and S_AXI_WREADY) = '1';  --Client ready to read address/data        
            S_AXI_BREADY<='1';
        wait until S_AXI_BVALID = '1';  -- Write result valid
            assert S_AXI_BRESP = "00" report "AXI data not written" severity failure;
            S_AXI_AWVALID<='0';
            S_AXI_WVALID<='0';
            S_AXI_BREADY<='1';
        wait until S_AXI_BVALID = '0';  -- All finished
            S_AXI_BREADY<='0';
    end loop;
 END PROCESS send;

  -- Initiate process which simulates a master wanting to read.
  -- This process is blocked on a "Read Flag" (readIt).
  -- When the flag goes to 1, the process exits the wait state and
  -- execute a read transaction.
  read : PROCESS
  BEGIN
    S_AXI_ARVALID<='0';
    S_AXI_RREADY<='0';
     loop
         wait until readIt = '1';
         wait until S_AXI_ACLK= '0';
             S_AXI_ARVALID<='1';
             S_AXI_RREADY<='1';
         wait until (S_AXI_RVALID and S_AXI_ARREADY) = '1';  --Client provided data
            assert S_AXI_RRESP = "00" report "AXI data not written" severity failure;
             S_AXI_ARVALID<='0';
            S_AXI_RREADY<='0';
     end loop;
  END PROCESS read;


 -- 
 tb : PROCESS
 BEGIN
        S_AXI_ARESETN<='1';
        sendIt<='0';
        readIt<= '0';
        wait for 15 ns;
        S_AXI_ARESETN<='0';
     
    
--write        
        S_AXI_AWADDR<="00000010";
        S_AXI_WDATA<=x"00000000";
        S_AXI_WSTRB<=b"0000";
        sendIt<='1';                --Start AXI Write to Slave
        wait for 5 ns; sendIt<='0'; --Clear Start Send Flag
        wait until S_AXI_BVALID = '1';
        wait until S_AXI_BVALID = '0';  --AXI Write finished
 --write        
        S_AXI_AWADDR<="00000011";
        S_AXI_WDATA<=x"00000001";
        S_AXI_WSTRB<=b"0000";
        sendIt<='1';                --Start AXI Write to Slave
        wait for 5 ns; sendIt<='0'; --Clear Start Send Flag
        wait until S_AXI_BVALID = '1';
        wait until S_AXI_BVALID = '0';  --AXI Write finished
        
--read 
        S_AXI_ARADDR<="00000001";
        readIt<='1';                --Start AXI Read from Slave
        wait for 5 ns; readIt<='0'; --Clear "Start Read" Flag
        wait until S_AXI_RVALID = '1';
        wait until S_AXI_RVALID = '0';
        
        --read 
        S_AXI_ARADDR<="00000001";
        readIt<='1';                --Start AXI Read from Slave
        wait for 5 ns; readIt<='0'; --Clear "Start Read" Flag
        wait until S_AXI_RVALID = '1';
        wait until S_AXI_RVALID = '0';





--write        
        S_AXI_AWADDR<="00000010";
        S_AXI_WDATA<=x"00000000";
        S_AXI_WSTRB<=b"0000";
        sendIt<='1';                --Start AXI Write to Slave
        wait for 5 ns; sendIt<='0'; --Clear Start Send Flag
        wait until S_AXI_BVALID = '1';
        wait until S_AXI_BVALID = '0';  --AXI Write finished
        wait for 50 ns;
 --write        
        S_AXI_AWADDR<="00000011";
        S_AXI_WDATA<=x"00000001";
        S_AXI_WSTRB<=b"0000";
        sendIt<='1';                --Start AXI Write to Slave
        wait for 5 ns; sendIt<='0'; --Clear Start Send Flag
        wait until S_AXI_BVALID = '1';
        wait until S_AXI_BVALID = '0';  --AXI Write finished
        
        

--read 
        S_AXI_ARADDR<="00000000";
        readIt<='1';                --Start AXI Read from Slave
        wait for 5 ns; readIt<='0'; --Clear "Start Read" Flag
        wait until S_AXI_RVALID = '1';
        wait until S_AXI_RVALID = '0';
--read 
        S_AXI_ARADDR<="00000001";
        readIt<='1';                --Start AXI Read from Slave
        wait for 5 ns; readIt<='0'; --Clear "Start Read" Flag
        wait until S_AXI_RVALID = '1';
        wait until S_AXI_RVALID = '0';         
               
     wait; -- will wait forever
 END PROCESS tb;


end Behavioral;