library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
library std;
use std.textio.all;

entity ImageReader is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           image_data_r : out STD_LOGIC_VECTOR(7 downto 0); -- Red value
           image_data_g : out STD_LOGIC_VECTOR(7 downto 0); -- Green value
           image_data_b : out STD_LOGIC_VECTOR(7 downto 0); -- Blue value
           resolution : out INTEGER);
end ImageReader;

architecture Behavioral of ImageReader is
begin
    process
        file img_file : text open read_mode is "C:/Users/alexa/Documents/.Semester 3/PSD/PSD_PA06/image_for_vhdl.txt";
        variable line : line;
        variable width, height : INTEGER;
        variable r, g, b : INTEGER;
    begin
        wait until rising_edge(clk);
        if rst = '1' then
            -- Initialize or reset
            resolution <= 0;
            image_data_r <= (others => '0');
            image_data_g <= (others => '0');
            image_data_b <= (others => '0');
        else
            -- Read resolution from file (assume line format is correct)
            if not endfile(img_file) then
                readline(img_file, line);
                read(line, width); -- Read width
                readline(img_file, line);
                read(line, height); -- Read height
                resolution <= width * height;
                -- Read and output RGB values
                while not endfile(img_file) loop
                    readline(img_file, line);
                    read(line, r);
                    read(line, g);
                    read(line, b);
                    image_data_r <= std_logic_vector(to_unsigned(r, 8));
                    image_data_g <= std_logic_vector(to_unsigned(g, 8));
                    image_data_b <= std_logic_vector(to_unsigned(b, 8));
                    wait for 10 ns; -- Add delay to ensure data is processed
                end loop;
            end if;
        end if;
    end process;
end Behavioral;
