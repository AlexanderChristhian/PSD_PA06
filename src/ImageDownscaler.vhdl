library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
library std;
use std.textio.all;

use work.package_imageArray.all;

entity ImageReader is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           image_data_r : out STD_LOGIC_VECTOR(7 downto 0); -- Red value
           image_data_g : out STD_LOGIC_VECTOR(7 downto 0); -- Green value
           image_data_b : out STD_LOGIC_VECTOR(7 downto 0); -- Blue value
           resolution : out INTEGER;
           done : buffer STD_LOGIC;  -- Changed from 'out' to 'buffer'
           downscaled_done : out STD_LOGIC;
           downscaled_width : out INTEGER;
           downscaled_height : out INTEGER;
           output_image : out image_process(0 to 511, 0 to 511));
end ImageReader;

architecture Structural of ImageReader is
    type pixel_array is array (0 to 1023, 0 to 1023) of RGB; -- Adjust size as needed

    component BoxSampling
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
    end component;

    type state_type is (IDLE, READ_RESOLUTION, READ_PIXEL, DOWNSCALE);
    signal state : state_type := IDLE;
    signal downscale_factor : INTEGER := 2; -- Example downscale factor
    signal r_array : image_process(0 to 1023, 0 to 1023); -- Adjust size as needed
    signal downscaled_image : image_process(0 to 511, 0 to 511); -- Adjust size as needed
    -- Removed duplicate output_image signal declaration
    signal row, col : INTEGER := 0;
    signal box_sampling_done : STD_LOGIC := '0';  -- Renamed from 'done' to 'box_sampling_done'
    signal width, height : INTEGER := 0;

begin
    uut: BoxSampling
        Port map (
            clk => clk,
            rst => rst,
            width => width,
            height => height,
            downscale_factor => downscale_factor,
            r_array => r_array,
            image_data_r => image_data_r,
            image_data_g => image_data_g,
            image_data_b => image_data_b,
            done => box_sampling_done  -- Use the new signal name
        );

    process
        file img_file : text open read_mode is "C:/Users/alexa/Documents/.Semester 3/PSD/PSD_PA06/image_for_vhdl.txt";
        variable line_buffer : line;
        variable r, g, b : INTEGER;
        variable width_var, height_var : INTEGER;
    begin
        wait until rising_edge(clk);
        if rst = '1' then
            state <= IDLE;
            resolution <= 0;
            image_data_r <= (others => '0');
            image_data_g <= (others => '0');
            image_data_b <= (others => '0');
            row <= 0;
            col <= 0;
            downscaled_done <= '0';
        else
            case state is
                when IDLE =>
                    if not endfile(img_file) then
                        state <= READ_RESOLUTION;
                    end if;
                when READ_RESOLUTION =>
                    readline(img_file, line_buffer);
                    read(line_buffer, width_var); -- Read width
                    width <= width_var;
                    readline(img_file, line_buffer);
                    read(line_buffer, height_var); -- Read height
                    height <= height_var;
                    resolution <= (width / downscale_factor) * (height / downscale_factor);
                    downscaled_width <= width / downscale_factor;
                    downscaled_height <= height / downscale_factor;
                    state <= READ_PIXEL;
                when READ_PIXEL =>
                    if not endfile(img_file) then
                        readline(img_file, line_buffer);
                        read(line_buffer, r);
                        read(line_buffer, g);
                        read(line_buffer, b);
                        r_array(row, col).RED <= r;
                        r_array(row, col).GREEN <= g;
                        r_array(row, col).BLUE <= b;
                        col <= col + 1;
                        if col = width then
                            col <= 0;
                            row <= row + 1;
                            if row = height then
                                state <= DOWNSCALE;
                                row <= 0;
                            end if;
                        end if;
                    end if;
                when DOWNSCALE =>
                    if box_sampling_done = '1' then  -- Use the new signal name
                        -- Copy downscaled image to output signals
                        for i in 0 to (height / downscale_factor) - 1 loop
                            for j in 0 to (width / downscale_factor) - 1 loop
                                output_image(i, j) <= downscaled_image(i, j);
                            end loop;
                        end loop;
                        downscaled_done <= '1';
                        done <= '1';  -- Set the port signal
                        state <= IDLE;
                    end if;
            end case;
        end if;
    end process;
end Structural;
