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
           done : buffer STD_LOGIC);  -- Changed from 'out' to 'buffer'
end BoxSampling;

architecture Behavioral of BoxSampling is
    signal r_sum, g_sum, b_sum : INTEGER := 0;
    signal row, col : INTEGER := 0;
    signal block_row, block_col : INTEGER := 0;
    signal downscaled_image : image_process(0 to 511, 0 to 511); -- Adjust size as needed
    signal downscale_row, downscale_col : INTEGER := 0;
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
            downscale_row <= 0;
            downscale_col <= 0;
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
                downscaled_image(downscale_row, downscale_col).RED <= r_sum / (downscale_factor * downscale_factor);
                downscaled_image(downscale_row, downscale_col).GREEN <= g_sum / (downscale_factor * downscale_factor);
                downscaled_image(downscale_row, downscale_col).BLUE <= b_sum / (downscale_factor * downscale_factor);
                downscale_col <= downscale_col + 1;
                if downscale_col = (width / downscale_factor) then
                    downscale_col <= 0;
                    downscale_row <= downscale_row + 1;
                    if downscale_row = (height / downscale_factor) then
                        done <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
