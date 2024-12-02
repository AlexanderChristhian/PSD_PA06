library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

package package_imageArray is
    -- Type for storing RGB value of each pixel:
    subtype COLOR is INTEGER range 0 to 255;
    type RGB is record
        RED     : COLOR;
        GREEN   : COLOR;
        BLUE    : COLOR;
    end record;

    -- Type for storing image pixel containing RGB:
    type image_process is array (natural range <>, natural range <>) of RGB;

end package package_imageArray;
