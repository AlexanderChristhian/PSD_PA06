-- RGBPackage.vhdl
-- Package berisi definisi tipe data dan fungsi yang digunakan untuk mengolah array gambar

-- Library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
library std;
use std.textio.all;

-- Package
package package_imageArray is
    -- Tipe data
    subtype COLOR is INTEGER range 0 to 255;
    -- Record type for RGB
    type RGB is record
        RED     : COLOR;
        GREEN   : COLOR;
        BLUE    : COLOR;
    end record;

    -- Impure functions untuk mendapatkan dimensi gambar
    impure function get_input_width return INTEGER;
    impure function get_input_height return INTEGER;
    impure function get_output_width return INTEGER;
    impure function get_output_height return INTEGER;
    impure function get_downscale_factor return INTEGER;

    -- Tipe array untuk gambar
    type image_array is array (natural range <>, natural range <>) of RGB;

    -- Fucntion untuk menghitung ukuran gambar yang di-downscale
    function calculate_downscaled_size(size: INTEGER; factor: INTEGER) return INTEGER;
end package;

-- Package body
package body package_imageArray is
    -- Implementasi fungsi-fungsi yang didefinisikan di package
    impure function get_input_width return INTEGER is
        file img_file: text;
        variable line_buffer: line;
        variable width: INTEGER;
    -- Membuka file gambar dan membaca lebar gambar lalu mereturn nilai lebar
    begin
        file_open(img_file, "C:/Users/alexa/Documents/.Semester 3/PSD/PSD_PA06/image_for_vhdl.txt", read_mode);
        readline(img_file, line_buffer);
        read(line_buffer, width);
        file_close(img_file);
        return width;
    end function;

    -- Implementasi fungsi get_input_height
    impure function get_input_height return INTEGER is
        file img_file: text;
        variable line_buffer: line;
        variable height, skip: INTEGER;
    -- Membuka file gambar dan membaca tinggi gambar lalu mereturn nilai tinggi
    begin
        file_open(img_file, "C:/Users/alexa/Documents/.Semester 3/PSD/PSD_PA06/image_for_vhdl.txt", read_mode);
        readline(img_file, line_buffer); -- Skip width
        readline(img_file, line_buffer);
        read(line_buffer, height);
        file_close(img_file);
        return height;
    end function;

    -- Implementasi fungsi get_output_width
    impure function get_output_width return INTEGER is
    begin
        return get_input_width / get_downscale_factor;
    end function;

    -- Implementasi fungsi get_output_height
    impure function get_output_height return INTEGER is
    begin
        return get_input_height / get_downscale_factor;
    end function;

    -- Implementasi fungsi get_downscale_factor
    impure function get_downscale_factor return INTEGER is
        file img_file: text;
        variable line_buffer: line;
        variable factor: INTEGER;
    -- Membuka file gambar dan membaca faktor downsampling lalu mereturn nilai faktor
    begin
        file_open(img_file, "C:/Users/alexa/Documents/.Semester 3/PSD/PSD_PA06/image_for_vhdl.txt", read_mode);
        readline(img_file, line_buffer); -- Skip width
        readline(img_file, line_buffer);
        readline(img_file, line_buffer);
        read(line_buffer, factor);
        file_close(img_file);
        return factor;
    end function;

    -- Implementasi fungsi calculate_downscaled_size
    function calculate_downscaled_size(size: INTEGER; factor: INTEGER) return INTEGER is
    begin
        return size/factor;
    end function;
end package body package_imageArray;
