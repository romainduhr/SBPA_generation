
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.12.2023 09:08:56
-- Design Name: 
-- Module Name: semi_random_binary_flux - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity semi_random_binary_flux is
    Port (clk_100Mhz : in std_logic;
          initial_flux: out std_logic;
          i_flux : out std_logic;
          q_flux : out std_logic;
          sw : in std_logic;
          clock_out : out std_logic
          );
end semi_random_binary_flux;

architecture Behavioral of semi_random_binary_flux is

signal cmp : integer range 0 to 2500 := 0 ;
signal clk_20Khz : std_logic:= '0';
signal d_latch : std_logic_vector(0 to 10);
signal start : std_logic:= '0';
signal odd : std_logic:='0';
signal next_i_flux : std_logic;
begin

initial_flux <= d_latch(10);
clock_out <= clk_20Khz;

process(clk_100Mhz)
begin

if rising_edge(clk_100Mhz) then
    if cmp >= 2499 then
        cmp <= 0; 
        -- clk_20MHz 
        if clk_20Khz = '0' then 
            clk_20Khz <= '1';
        else 
            clk_20Khz <= '0';
        end if;
    else
        cmp <= cmp +1;
    end if;
end if;

end process;

process(clk_20Khz)
begin
if rising_edge(clk_20Khz) then
    -- Lancement 
    if sw = '1' and start = '0' then  
    d_latch(0) <= '1';
    start <= '1';
    else
        -- D-latch
        for i in 0 to 9 loop
        d_latch(i+1) <= d_latch(i);
        end loop;
        -- Rebouclage
        d_latch(0) <= (d_latch(10) xor d_latch(1));
        end if;
end if;
end process;

-- process trame i et q
process(clk_20Khz)
begin

if rising_edge(clk_20Khz) then
    if odd = '0' then
        next_i_flux <= d_latch(10);
        odd <= '1';
    else 
        q_flux <= d_latch(10);
        i_flux <= next_i_flux;
        odd <= '0';
    end if;

end if;

end process;
end Behavioral;