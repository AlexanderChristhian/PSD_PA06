library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
library std;
use std.textio.all;

use work.package_imageArray.all;

entity TbImageDownscaler is
end TbImageDownscaler;

architecture Behavioral of TbImageDownscaler is
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '1';
    signal resolution : INTEGER;
    signal done : STD_LOGIC;
    signal downscaled_done : STD_LOGIC;
    signal downscaled_width, downscaled_height : INTEGER;
    signal downscale_factor : INTEGER := 2; -- Default value
    signal input_width, input_height : INTEGER := 0;
    signal input_image : image_array(0 to get_input_width-1, 0 to get_input_height-1);
    signal output_image : image_array(0 to get_output_width-1, 0 to get_output_height-1);

    component ImageDownscaler
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               image_input : in image_array(0 to get_input_width-1, 0 to get_input_height-1);
               input_width : in INTEGER;
               input_height : in INTEGER;
               resolution : out INTEGER;
               done : buffer STD_LOGIC;
               downscaled_done : out STD_LOGIC;
               output_image : out image_array(0 to get_output_width-1, 0 to get_output_height-1);
               downscaled_width : out INTEGER;
               downscaled_height : out INTEGER;
               downscale_factor : in INTEGER);
    end component;

begin
    uut: ImageDownscaler
        port map (
            clk => clk,
            rst => rst,
            image_input => input_image,
            input_width => input_width,
            input_height => input_height,
            resolution => resolution,
            done => done,
            downscaled_done => downscaled_done,
            output_image => output_image,
            downscaled_width => downscaled_width,
            downscaled_height => downscaled_height,
            downscale_factor => downscale_factor -- Added mapping
        );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;

    -- File reading process
    file_read_proc: process
        file img_file : text;
        variable line_buffer : line;
        variable r, g, b : INTEGER;
        variable row, col : INTEGER := 0;
        variable width_temp, height_temp : INTEGER;
        variable temp_image : image_array(0 to get_input_width-1, 0 to get_input_height-1);
        variable down_width, down_height : INTEGER;
        variable downscale_factor_var : INTEGER ; -- Default value
    begin
        file_open(img_file, "C:/Users/alexa/Documents/.Semester 3/PSD/PSD_PA06/image_for_vhdl.txt", read_mode);
        
        -- Read dimensions
        readline(img_file, line_buffer);
        read(line_buffer, width_temp);
        readline(img_file, line_buffer);
        read(line_buffer, height_temp);
        readline(img_file, line_buffer);
        read(line_buffer, downscale_factor_var);
        downscale_factor <= downscale_factor_var; -- Assign to signal
        
        -- Calculate sizes and initialize arrays
        down_width := calculate_downscaled_size(width_temp, 2);
        down_height := calculate_downscaled_size(height_temp, 2);
        
        -- Initialize image with zeros
        for i in 0 to width_temp-1 loop
            for j in 0 to height_temp-1 loop
                temp_image(i, j).RED := 0;
                temp_image(i, j).GREEN := 0;
                temp_image(i, j).BLUE := 0;
            end loop;
        end loop;

        input_width <= width_temp;
        input_height <= height_temp;
        
        -- Read pixel data into temp_image
        while not endfile(img_file) loop
            readline(img_file, line_buffer);
            read(line_buffer, r);
            read(line_buffer, g);
            read(line_buffer, b);
            
            temp_image(row, col).RED := r;
            temp_image(row, col).GREEN := g;
            temp_image(row, col).BLUE := b;
            
            if col = width_temp - 1 then
                col := 0;
                row := row + 1;
            else
                col := col + 1;
            end if;
        end loop;
        

        -- Assign to signals after reading is complete
        input_width <= width_temp;
        input_height <= height_temp;
        input_image <= temp_image; -- Now assigning to signal
        
        wait;
    end process;

    -- Stimulus process
    stim_proc: process
        variable output_line : line;
        file output_file : text open write_mode is "C:/Users/alexa/Documents/.Semester 3/PSD/PSD_PA06/Output.txt";
    begin
        -- Wait for reset to complete
        wait for 100 ns;
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        -- Wait for downscaling to complete
        wait until downscaled_done = '1';
        -- Add additional wait to ensure signals are stable
        wait for 50 ns;

        -- Write dimensions first
        write(output_line, downscaled_width);
        writeline(output_file, output_line);

        write(output_line, downscaled_height);
        writeline(output_file, output_line);

        -- Write pixel data
        for i in 0 to downscaled_height - 1 loop
            for j in 0 to downscaled_width - 1 loop
                write(output_line, output_image(i, j).RED);
                write(output_line, string'(" "));
                write(output_line, output_image(i, j).GREEN);
                write(output_line, string'(" "));
                write(output_line, output_image(i, j).BLUE);
                writeline(output_file, output_line);
            end loop;
        end loop;

        file_close(output_file);

        -- Signal completion
        report "Simulation completed successfully";
        wait;
    end process;
end Behavioral;
