-- BoxSampling.vhdl
-- Berfungsi untuk melakukan downsampling gambar dengan metode Box Sampling

-- Library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Package
use work.package_imageArray.all;

-- Entity
entity BoxSampling is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           width : in INTEGER;
           height : in INTEGER;
           downscale_factor : in INTEGER;
           r_array : in image_array(0 to 7, 0 to 7); -- Input image
           downscaled_image : out image_array(0 to 3, 0 to 3); -- Output image
           done : buffer STD_LOGIC);
end BoxSampling;

-- Architecture Behavioral
architecture Behavioral of BoxSampling is
    -- Signal
    signal downscale_row, downscale_col : INTEGER := 0;
begin
    process(clk, rst)
        variable r_sum, g_sum, b_sum : INTEGER;
    begin
        if rst = '1' then
            downscale_row <= 0;
            downscale_col <= 0;
            done <= '0';
        elsif rising_edge(clk) then
            if downscale_col < 4 and downscale_row < 4 then  -- Fixed size for 8x8->4x4
                r_sum := 0;
                g_sum := 0;
                b_sum := 0;
                
                -- Fixed 2x2 box sampling
                for col in 0 to 1 loop
                    for row in 0 to 1 loop
                        r_sum := r_sum + r_array(downscale_row * 2 + row, downscale_col * 2 + col).RED;
                        g_sum := g_sum + r_array(downscale_row * 2 + row, downscale_col * 2 + col).GREEN;
                        b_sum := b_sum + r_array(downscale_row * 2 + row, downscale_col * 2 + col).BLUE;
                    end loop;
                end loop;

                -- Average of 4 pixels (2x2)
                downscaled_image(downscale_row, downscale_col).RED <= r_sum / 4;
                downscaled_image(downscale_row, downscale_col).GREEN <= g_sum / 4;
                downscaled_image(downscale_row, downscale_col).BLUE <= b_sum / 4;

                -- Fixed size updates
                if downscale_row = 3 then
                    downscale_row <= 0;
                    if downscale_col = 3 then
                        done <= '1';
                    else
                        downscale_col <= downscale_col + 1;
                    end if;
                else
                    downscale_row <= downscale_row + 1;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
