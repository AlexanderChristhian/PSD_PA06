-- TbImageDownscaler.vhdl
-- Testbench untuk ImageDownscaler

-- Library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
library std;
use std.textio.all;

-- Package
use work.package_imageArray.all;

-- Entity (modified to indicate this is a testbench)
entity TbImageDownscaler is
    -- This is a testbench, no ports needed
end TbImageDownscaler;

-- Architecture
architecture Behavioral of TbImageDownscaler is
    -- Add attribute to prevent synthesis
    attribute dont_touch : string;
    attribute dont_touch of Behavioral : architecture is "true";

    -- Clock and control signals
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '1';
    signal resolution : INTEGER;
    signal done : STD_LOGIC;
    signal downscaled_done : STD_LOGIC;
    signal downscaled_width, downscaled_height : INTEGER := 4;
    signal downscale_factor : INTEGER := 2;
    
    -- Image dimensions (fixed to 8x8)
    signal input_width : INTEGER := 8;
    signal input_height : INTEGER := 8;
    
    -- Image arrays with smaller fixed sizes (8x8 -> 4x4)
    signal input_image : image_array(0 to 7, 0 to 7);
    signal output_image : image_array(0 to 3, 0 to 3);

    -- Component declaration
    component ImageDownscaler
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               image_input : in image_array(0 to 7, 0 to 7);
               input_width : in INTEGER;
               input_height : in INTEGER;
               resolution : out INTEGER;
               done : buffer STD_LOGIC;
               downscaled_done : out STD_LOGIC;
               output_image : out image_array(0 to 3, 0 to 3);
               downscaled_width : out INTEGER;
               downscaled_height : out INTEGER;
               downscale_factor : in INTEGER);
    end component;

-- Begin process
begin
    uut: ImageDownscaler
        port map (
            clk => clk,
            rst => rst,
            image_input => input_image, -- Input image
            input_width => input_width,
            input_height => input_height,
            resolution => resolution,
            done => done,
            downscaled_done => downscaled_done,
            output_image => output_image,
            downscaled_width => downscaled_width,
            downscaled_height => downscaled_height,
            downscale_factor => downscale_factor 
        );

    -- Clock process
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;

    -- Memproses file gambar
    file_read_proc: process
        -- Variable declarations with smaller fixed sizes
        file img_file : text;  -- Add file declaration here
        variable row, col : INTEGER := 0;
        variable r, g, b : INTEGER;
        variable line_buffer : line;
        variable temp_image : image_array(0 to 7, 0 to 7);
    begin
        -- Initialize temp_image with zeros
        for i in 0 to 7 loop
            for j in 0 to 7 loop
                temp_image(j, i).RED := 0;
                temp_image(j, i).GREEN := 0;
                temp_image(j, i).BLUE := 0;
            end loop;
        end loop;

        -- Open file with explicit file_open
        file_open(img_file, "C:/Users/alexa/Documents/.Semester 3/PSD/PSD_PA06/image_for_vhdl.txt", read_mode);
        
        -- Skip dimension readings as we're using fixed sizes
        readline(img_file, line_buffer); -- Skip width
        readline(img_file, line_buffer); -- Skip height
        readline(img_file, line_buffer); -- Skip downscale factor
        
        -- Read pixel data
        while not endfile(img_file) loop
            readline(img_file, line_buffer);
            read(line_buffer, r);
            read(line_buffer, g);
            read(line_buffer, b);
            
            if row < 8 and col < 8 then
                temp_image(row, col).RED := r;
                temp_image(row, col).GREEN := g;
                temp_image(row, col).BLUE := b;
                
                if row = 7 then
                    row := 0;
                    col := col + 1;
                else
                    row := row + 1;
                end if;
            end if;
        end loop;
        
        input_image <= temp_image;
        wait;
    end process;

    -- Stimulus process
    stim_proc: process
        variable output_line : line;
        file output_file : text;
    begin
        file_open(output_file, "C:/Users/alexa/Documents/.Semester 3/PSD/PSD_PA06/Output.txt", write_mode);
        
        wait for 100 ns;
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        wait until downscaled_done = '1';
        wait for 50 ns;

        -- Write using fixed 4x4 dimensions
        write(output_line, 4);  -- Changed from 256 to 4
        writeline(output_file, output_line);
        write(output_line, 4);  -- Changed from 256 to 4
        writeline(output_file, output_line);

        -- Write 4x4 output image data
        for i in 0 to 3 loop     -- Changed from 256-1 to 3
            for j in 0 to 3 loop -- Changed from 256-1 to 3
                write(output_line, output_image(j, i).RED);
                write(output_line, string'(" "));
                write(output_line, output_image(j, i).GREEN);
                write(output_line, string'(" "));
                write(output_line, output_image(j, i).BLUE);
                writeline(output_file, output_line);
            end loop;
        end loop;
        
        file_close(output_file);
        report "Simulation completed successfully";
        wait;
    end process;
end Behavioral;
