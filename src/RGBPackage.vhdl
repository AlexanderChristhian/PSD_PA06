library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
library std;
use std.textio.all;

package package_imageArray is
    -- Basic type definitions
    subtype COLOR is INTEGER range 0 to 255;
    type RGB is record
        RED     : COLOR;
        GREEN   : COLOR;
        BLUE    : COLOR;
    end record;

    -- Functions to get dimensions
    impure function get_input_width return INTEGER;
    impure function get_input_height return INTEGER;
    impure function get_output_width return INTEGER;
    impure function get_output_height return INTEGER;
    impure function get_downscale_factor return INTEGER;

    -- Array type with dimensions from functions
    type image_array is array (natural range <>, natural range <>) of RGB;

    -- Function for downscaling calculation
    function calculate_downscaled_size(size: INTEGER; factor: INTEGER) return INTEGER;
end package;

package body package_imageArray is
    -- Implementation of dimension functions
    impure function get_input_width return INTEGER is
        file img_file: text;
        variable line_buffer: line;
        variable width: INTEGER;
    begin
        file_open(img_file, "C:/Users/alexa/Documents/.Semester 3/PSD/PSD_PA06/image_for_vhdl.txt", read_mode);
        readline(img_file, line_buffer);
        read(line_buffer, width);
        file_close(img_file);
        return width;
    end function;

    impure function get_input_height return INTEGER is
        file img_file: text;
        variable line_buffer: line;
        variable height, skip: INTEGER;
    begin
        file_open(img_file, "C:/Users/alexa/Documents/.Semester 3/PSD/PSD_PA06/image_for_vhdl.txt", read_mode);
        readline(img_file, line_buffer); -- Skip width
        readline(img_file, line_buffer);
        read(line_buffer, height);
        file_close(img_file);
        return height;
    end function;

    impure function get_output_width return INTEGER is
    begin
        return get_input_width / get_downscale_factor;
    end function;

    impure function get_output_height return INTEGER is
    begin
        return get_input_height / get_downscale_factor;
    end function;

    impure function get_downscale_factor return INTEGER is
        file img_file: text;
        variable line_buffer: line;
        variable factor: INTEGER;
    begin
        file_open(img_file, "C:/Users/alexa/Documents/.Semester 3/PSD/PSD_PA06/image_for_vhdl.txt", read_mode);
        readline(img_file, line_buffer); -- Skip width
        readline(img_file, line_buffer);
        readline(img_file, line_buffer);
        read(line_buffer, factor);
        file_close(img_file);
        return factor;
    end function;

    function calculate_downscaled_size(size: INTEGER; factor: INTEGER) return INTEGER is
    begin
        return size/factor;
    end function;
end package body package_imageArray;
