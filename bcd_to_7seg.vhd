LIBRARY ieee;
USE ieee.std_logic_1164.all;
 
entity bcd_to_7seg is
    port (
        bin : in  std_logic_vector(3 downto 0);
        hex : out std_logic_vector(6 downto 0)
    );
end entity bcd_to_7seg;
 
architecture rtl of bcd_to_7seg is
begin
    process (bin)
    begin
        case bin is
            when "0000" => hex <= "1000000"; -- 0
            when "0001" => hex <= "1111001"; -- 1
            when "0010" => hex <= "0100100"; -- 2
            when "0011" => hex <= "0110000"; -- 3
            when "0100" => hex <= "0011001"; -- 4
            when "0101" => hex <= "0010010"; -- 5
            when "0110" => hex <= "0000010"; -- 6
            when "0111" => hex <= "1111000"; -- 7
            when "1000" => hex <= "0000000"; -- 8
            when "1001" => hex <= "0010000"; -- 9
            when others => hex <= "1111111"; -- apagado
        end case;
    end process;
end architecture rtl;