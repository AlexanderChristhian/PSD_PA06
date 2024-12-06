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
    -- Type definitions
    subtype COLOR is INTEGER range 0 to 255;
    type RGB is record
        RED     : COLOR;
        GREEN   : COLOR;
        BLUE    : COLOR;
    end record;

    -- Array type for images
    type image_array is array (natural range <>, natural range <>) of RGB;

    -- Function for calculating downscaled size
    function calculate_downscaled_size(size: INTEGER; factor: INTEGER) return INTEGER;
end package;

-- Package body
package body package_imageArray is
    -- Implementasi fungsi calculate_downscaled_size
    function calculate_downscaled_size(size: INTEGER; factor: INTEGER) return INTEGER is
    begin
        return size/factor;
    end function;
end package body package_imageArray;
