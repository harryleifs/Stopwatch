LIBRARY ieee;
USE ieee.std_logic_1164.all;
 
entity stopwatch is
    generic (
        PRESCALE : positive := 5_000_000  
    );
    port (
        CLOCK_50 : in  std_logic;
        BUTTON   : in  std_logic_vector(2 downto 0);
        SW       : in  std_logic_vector(9 downto 0);
        HEX0_D   : out std_logic_vector(6 downto 0);
        HEX1_D   : out std_logic_vector(6 downto 0);
        HEX2_D   : out std_logic_vector(6 downto 0);
        HEX3_D   : out std_logic_vector(6 downto 0);
        HEX0_DP  : out std_logic;
        HEX1_DP  : out std_logic;
        HEX2_DP  : out std_logic;
        HEX3_DP  : out std_logic
    );
end entity stopwatch;
 
architecture structural of stopwatch is
 
    signal rst, sync_clr, go : std_logic;
 
    
    signal tick_pre   : std_logic;  
    signal tick_tenth : std_logic;  
    signal tick_unit  : std_logic;  
 
    
    signal bcd_tenth : std_logic_vector(3 downto 0);
    signal bcd_unit  : std_logic_vector(3 downto 0);
    signal bcd_ten   : std_logic_vector(3 downto 0);
 
begin
 
    
    rst      <= not BUTTON(0);
    sync_clr <= not BUTTON(1);
    go       <= SW(0);
 
    
    u_pre : entity work.mod_counter
        generic map (N => 23, M => PRESCALE)
        port map (
            clk      => CLOCK_50,
            rst      => rst,
            sync_clr => sync_clr,
            ena      => go,
            count    => open,
            max_tick => tick_pre
        );
 
    
    u_tenth : entity work.mod_counter
        generic map (N => 4, M => 10)
        port map (
            clk      => CLOCK_50,
            rst      => rst,
            sync_clr => sync_clr,
            ena      => tick_pre,
            count    => bcd_tenth,
            max_tick => tick_tenth
        );
 
    
    u_unit : entity work.mod_counter
        generic map (N => 4, M => 10)
        port map (
            clk      => CLOCK_50,
            rst      => rst,
            sync_clr => sync_clr,
            ena      => tick_tenth,
            count    => bcd_unit,
            max_tick => tick_unit
        );
 
    
    u_ten : entity work.mod_counter
        generic map (N => 4, M => 10)
        port map (
            clk      => CLOCK_50,
            rst      => rst,
            sync_clr => sync_clr,
            ena      => tick_unit,
            count    => bcd_ten,
            max_tick => open
        );
 
    
    u_hex0 : entity work.bcd_to_7seg
        port map (bin => bcd_tenth, hex => HEX0_D);
 
    u_hex1 : entity work.bcd_to_7seg
        port map (bin => bcd_unit, hex => HEX1_D);
 
    u_hex2 : entity work.bcd_to_7seg
        port map (bin => bcd_ten, hex => HEX2_D);
 
    
    HEX3_D <= (others => '1');
 
    
    HEX0_DP <= '1';
    HEX1_DP <= '0';
    HEX2_DP <= '1';
    HEX3_DP <= '1';
 
end architecture structural;