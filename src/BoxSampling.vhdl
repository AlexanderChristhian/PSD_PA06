library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.package_imageArray.all;

entity BoxSampling is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           width : in INTEGER;
           height : in INTEGER;
           downscale_factor : in INTEGER;
           r_array : in image_process; -- Adjust size as needed
           image_data_r : out STD_LOGIC_VECTOR(7 downto 0);
           image_data_g : out STD_LOGIC_VECTOR(7 downto 0);
           image_data_b : out STD_LOGIC_VECTOR(7 downto 0);
           done : out STD_LOGIC);
end BoxSampling;

architecture Behavioral of BoxSampling is
    signal r_sum, g_sum, b_sum : INTEGER := 0;
    signal row, col : INTEGER := 0;
    signal block_row, block_col : INTEGER := 0;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            r_sum <= 0;
            g_sum <= 0;
            b_sum <= 0;
            row <= 0;
            col <= 0;
            block_row <= 0;
            block_col <= 0;
            done <= '0';
        elsif rising_edge(clk) then
            if block_row < (height / downscale_factor) and block_col < (width / downscale_factor) then
                r_sum <= 0;
                g_sum <= 0;
                b_sum <= 0;
                for row in 0 to downscale_factor - 1 loop
                    for col in 0 to downscale_factor - 1 loop
                        r_sum <= r_sum + r_array(block_row * downscale_factor + row, block_col * downscale_factor + col).RED;
                        g_sum <= g_sum + r_array(block_row * downscale_factor + row, block_col * downscale_factor + col).GREEN;
                        b_sum <= b_sum + r_array(block_row * downscale_factor + row, block_col * downscale_factor + col).BLUE;
                    end loop;
                end loop;
                image_data_r <= std_logic_vector(to_unsigned(r_sum / (downscale_factor * downscale_factor), 8));
                image_data_g <= std_logic_vector(to_unsigned(g_sum / (downscale_factor * downscale_factor), 8));
                image_data_b <= std_logic_vector(to_unsigned(b_sum / (downscale_factor * downscale_factor), 8));
                block_col <= block_col + 1;
                if block_col = (width / downscale_factor) then
                    block_col <= 0;
                    block_row <= block_row + 1;
                    if block_row = (height / downscale_factor) then
                        done <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
