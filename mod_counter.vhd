LIBRARY ieee;
USE ieee.std_logic_1164.all;
 
entity mod_counter is
    generic (
        N : positive := 4;    
        M : positive := 10    
    );
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        sync_clr : in  std_logic;
        ena      : in  std_logic;
        count    : out std_logic_vector(N-1 downto 0);
        max_tick : out std_logic
    );
end entity mod_counter;
 
architecture rtl of mod_counter is
 
    function int_to_slv(v : natural; w : positive) return std_logic_vector is
        variable r : std_logic_vector(w-1 downto 0);
        variable t : natural := v;
    begin
        for i in 0 to w-1 loop
            if (t mod 2) = 1 then
                r(i) := '1';
            else
                r(i) := '0';
            end if;
            t := t / 2;
        end loop;
        return r;
    end function;
 
    
    function inc(a : std_logic_vector) return std_logic_vector is
        variable r : std_logic_vector(a'range);
        variable c : std_logic := '1';
    begin
        for i in a'low to a'high loop
            r(i) := a(i) xor c;
            c    := a(i) and c;
        end loop;
        return r;
    end function;
 
    constant MAX_VAL : std_logic_vector(N-1 downto 0) := int_to_slv(M-1, N);
    constant ZERO    : std_logic_vector(N-1 downto 0) := (others => '0');
 
    signal r_reg : std_logic_vector(N-1 downto 0);
 
begin
 
    process (clk, rst)
    begin
        if rst = '1' then
            r_reg <= ZERO;
        elsif rising_edge(clk) then
            if sync_clr = '1' then
                r_reg <= ZERO;
            elsif ena = '1' then
                if r_reg = MAX_VAL then
                    r_reg <= ZERO;
                else
                    r_reg <= inc(r_reg);
                end if;
            end if;
        end if;
    end process;
 
    count    <= r_reg;
    max_tick <= '1' when (ena = '1' and r_reg = MAX_VAL) else '0';
 
end architecture rtl;