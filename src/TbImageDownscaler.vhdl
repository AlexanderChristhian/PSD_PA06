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

-- Entity
entity TbImageDownscaler is
end TbImageDownscaler;

-- Architecture
architecture Behavioral of TbImageDownscaler is
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '1';
    signal resolution : INTEGER;
    signal done : STD_LOGIC;
    signal downscaled_done : STD_LOGIC;
    signal downscaled_width, downscaled_height : INTEGER;
    signal downscale_factor : INTEGER := 2; -- Nilai default
    signal input_width, input_height : INTEGER := 0;
    signal input_image : image_array(0 to get_input_width-1, 0 to get_input_height-1); -- Input image
    signal output_image : image_array(0 to get_output_width-1, 0 to get_output_height-1); -- Output image

    -- Instansi komponen ImageDownscaler
    component ImageDownscaler
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               image_input : in image_array(0 to get_input_width-1, 0 to get_input_height-1); -- Input image
               input_width : in INTEGER;
               input_height : in INTEGER;
               resolution : out INTEGER;
               done : buffer STD_LOGIC;
               downscaled_done : out STD_LOGIC;
               output_image : out image_array(0 to get_output_width-1, 0 to get_output_height-1); -- Output image
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
        -- Variable
        file img_file : text;
        variable line_buffer : line;
        variable r, g, b : INTEGER;
        variable row, col : INTEGER := 0;
        variable width_temp, height_temp : INTEGER;
        variable temp_image : image_array(0 to get_input_width-1, 0 to get_input_height-1);
        variable down_width, down_height : INTEGER;
        variable downscale_factor_var : INTEGER ; 
    -- Mulai
    begin
        -- Buka file gambar
        file_open(img_file, "D:\Akademis\Teknik Komputer\Semester 3\PSD\Praktikum\PSD_PA06\image_for_vhdl.txt", read_mode);
        
        -- Memproses lebar, tinggi, dan faktor downsampling
        readline(img_file, line_buffer);
        read(line_buffer, width_temp);
        readline(img_file, line_buffer);
        read(line_buffer, height_temp);
        readline(img_file, line_buffer);
        read(line_buffer, downscale_factor_var);
        downscale_factor <= downscale_factor_var; 
        
        -- Menghitung lebar dan tinggi gambar yang sudah di-downscale
        down_width := calculate_downscaled_size(width_temp, 2);
        down_height := calculate_downscaled_size(height_temp, 2);
        
        -- Meninisialisasi array gambar sementara dengan nilai 0 pada setiap pixel dan setiap warna
        for i in 0 to height_temp-1 loop
            for j in 0 to width_temp-1 loop
                temp_image(j, i).RED := 0;
                temp_image(j, i).GREEN := 0;
                temp_image(j, i).BLUE := 0;
            end loop;
        end loop;
        
        -- Assign lebar dan tinggi gambar ke signal
        input_width <= width_temp;
        input_height <= height_temp;
        
        -- Memproses pixel gambar
        while not endfile(img_file) loop
            -- Membaca nilai R, G, B dari file
            readline(img_file, line_buffer);
            read(line_buffer, r);
            read(line_buffer, g);
            read(line_buffer, b);
            
            -- Assign nilai R, G, B ke array gambar sementara
            temp_image(row, col).RED := r;
            temp_image(row, col).GREEN := g;
            temp_image(row, col).BLUE := b;
            
            -- Update indeks
            if row = width_temp - 1 then
                row := 0;
                col := col + 1;
            else
                row := row + 1;
            end if;
        end loop;
        

        -- Mengassign array gambar sementara ke signal
        input_width <= width_temp;
        input_height <= height_temp;
        input_image <= temp_image; 
        
        wait;
    end process;

    -- Stimulus process
    stim_proc: process
        variable output_line : line;
        file output_file : text open write_mode is "D:\Akademis\Teknik Komputer\Semester 3\PSD\Praktikum\PSD_PA06\Output.txt";
    begin
        -- Tunggu hingga proses selesai
        wait for 100 ns;
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        -- Tunggu hingga proses selesai
        wait until downscaled_done = '1';
        -- Delay untuk menunggu proses selesai agar tidak ada gangguan saat menulis file
        wait for 50 ns;

        -- Menulis lebar dan tinggi output image ke file
        write(output_line, downscaled_width);
        writeline(output_file, output_line);

        write(output_line, downscaled_height);
        writeline(output_file, output_line);

        -- Menuliskan Output Image ke file
        for i in 0 to downscaled_height - 1 loop
            for j in 0 to downscaled_width - 1 loop
                write(output_line, output_image(j, i).RED);
                write(output_line, string'(" "));
                write(output_line, output_image(j, i).GREEN);
                write(output_line, string'(" "));
                write(output_line, output_image(j, i).BLUE);
                writeline(output_file, output_line);
            end loop;
        end loop;
        
        -- Tutup file
        file_close(output_file);

        -- Report simulation selesai
        report "Simulation completed successfully";
        wait;
    end process;
end Behavioral;
