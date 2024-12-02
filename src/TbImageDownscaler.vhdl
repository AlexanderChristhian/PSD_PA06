library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
library std;
use std.textio.all;

use work.package_imageArray.all;

entity TbImageReader is
end TbImageReader;

architecture Behavioral of TbImageReader is
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '1';
    signal image_data_r : STD_LOGIC_VECTOR(7 downto 0);
    signal image_data_g : STD_LOGIC_VECTOR(7 downto 0);
    signal image_data_b : STD_LOGIC_VECTOR(7 downto 0);
    signal resolution : INTEGER;
    file output_file : text open write_mode is "C:/Users/alexa/Documents/.Semester 3/PSD/PSD_PA06/Output.txt";

    component ImageReader
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               image_data_r : out STD_LOGIC_VECTOR(7 downto 0);
               image_data_g : out STD_LOGIC_VECTOR(7 downto 0);
               image_data_b : out STD_LOGIC_VECTOR(7 downto 0);
               resolution : out INTEGER);
    end component;

    function to_string(slv : STD_LOGIC_VECTOR) return string is
        variable result : string(1 to slv'length);
    begin
        for i in slv'range loop
            if slv(i) = '0' then
                result(slv'length - i + 1) := '0';
            else
                result(slv'length - i + 1) := '1';
            end if;
        end loop;
        return result;
    end function;

begin
    uut: ImageReader
        Port map (
            clk => clk,
            rst => rst,
            image_data_r => image_data_r,
            image_data_g => image_data_g,
            image_data_b => image_data_b,
            resolution => resolution
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

    -- Stimulus process
    stim_proc: process
        variable output_line : line;
    begin
        -- Initialize reset
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        -- Wait for some time to observe the behavior
        wait for 1000 ns;

        -- Write output data to file
        write(output_line, string'("Resolution: "));
        write(output_line, resolution);
        writeline(output_file, output_line);

        write(output_line, string'("Red: "));
        write(output_line, to_string(image_data_r));
        writeline(output_file, output_line);

        write(output_line, string'("Green: "));
        write(output_line, to_string(image_data_g));
        writeline(output_file, output_line);

        write(output_line, string'("Blue: "));
        write(output_line, to_string(image_data_b));
        writeline(output_file, output_line);

        -- End simulation
        wait;
    end process;
end Behavioral;
