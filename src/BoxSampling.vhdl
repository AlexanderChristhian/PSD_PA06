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
           r_array : in image_array(0 to get_input_width-1, 0 to get_input_height-1); -- Input image
           downscaled_image : out image_array(0 to get_output_width-1, 0 to get_output_height-1); -- Output image
           done : buffer STD_LOGIC);
end BoxSampling;

-- Architecture Behavioral
architecture Behavioral of BoxSampling is
    -- Signal
    signal downscale_row, downscale_col : INTEGER := 0;
-- Mulai proses
begin
    -- Proses
    process(clk, rst)
        -- Variable
        variable r_sum, g_sum, b_sum : INTEGER;
    -- Mulai
    begin
        -- Reset saat rst = 1
        if rst = '1' then
            downscale_row <= 0;
            downscale_col <= 0;
            done <= '0';
        -- Rising edge
        elsif rising_edge(clk) then
            if downscale_row < (height / downscale_factor) and downscale_col < (width / downscale_factor) then
                -- Reset sum saat awal iterasi
                r_sum := 0;
                g_sum := 0;
                b_sum := 0;
                
                -- Menghitung rata-rata warna dengan metode Box Sampling dengan faktor downscale untuk setiap pixel
                for row in 0 to downscale_factor - 1 loop
                    for col in 0 to downscale_factor - 1 loop
                        r_sum := r_sum + r_array(downscale_row * downscale_factor + row, downscale_col * downscale_factor + col).RED;
                        g_sum := g_sum + r_array(downscale_row * downscale_factor + row, downscale_col * downscale_factor + col).GREEN;
                        b_sum := b_sum + r_array(downscale_row * downscale_factor + row, downscale_col * downscale_factor + col).BLUE;
                    end loop;
                end loop;

                -- Mengassign nilai rata-rata warna ke pixel baru
                downscaled_image(downscale_row, downscale_col).RED <= r_sum / (downscale_factor * downscale_factor);
                downscaled_image(downscale_row, downscale_col).GREEN <= g_sum / (downscale_factor * downscale_factor);
                downscaled_image(downscale_row, downscale_col).BLUE <= b_sum / (downscale_factor * downscale_factor);

                -- Mengupdate indeks
                if downscale_col = (width / downscale_factor) - 1 then
                    downscale_col <= 0;
                    downscale_row <= downscale_row + 1;
                    -- Jika sudah sampai baris terakhir, maka selesai
                    if downscale_row = (height / downscale_factor) - 1 then
                        done <= '1';
                    end if;
                else
                    downscale_col <= downscale_col + 1;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
