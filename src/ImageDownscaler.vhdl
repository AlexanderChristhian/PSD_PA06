-- ImageDownscaler.vhdl
-- Berfungsi untuk sebagai bagian utama Downscaler

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
entity ImageDownscaler is
    -- Port
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           image_input : in image_array(0 to get_input_width-1, 0 to get_input_height-1); -- Input image
           input_width : in INTEGER;
           input_height : in INTEGER;
           resolution : out INTEGER;
           done : buffer STD_LOGIC;
           downscaled_done : out STD_LOGIC;
           downscaled_width : out INTEGER;
           downscaled_height : out INTEGER;
           output_image : out image_array(0 to get_output_width-1, 0 to get_output_height-1); -- Output image
           downscale_factor : in INTEGER);
end ImageDownscaler;

-- Architecture Structural
architecture Structural of ImageDownscaler is
    component BoxSampling
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               width : in INTEGER;
               height : in INTEGER;
               downscale_factor : in INTEGER;
               r_array : in image_array(0 to get_input_width-1, 0 to get_input_height-1); -- Input image
               downscaled_image : out image_array(0 to get_output_width-1, 0 to get_output_height-1); -- Output image
               done : buffer STD_LOGIC);
    end component;

    -- Signal
    signal r_array : image_array(0 to get_input_width-1, 0 to get_input_height-1);
    signal downscaled_image : image_array(0 to get_output_width-1, 0 to get_output_height-1);
    type state_type is (IDLE, PROCESS_INPUT, DOWNSCALE);
    signal state : state_type := IDLE;
    signal box_sampling_done : STD_LOGIC := '0';
    signal width, height : INTEGER := 0;

-- Process
begin
    -- BoxSampling component
    uut: BoxSampling
        Port map (
            clk => clk,
            rst => rst,
            width => width,
            height => height,
            downscale_factor => downscale_factor,
            r_array => r_array,
            downscaled_image => downscaled_image,
            done => box_sampling_done
        );

    -- Main process
    process(clk, rst)
    begin
        -- Reset
        if rst = '1' then
            state <= IDLE;
            resolution <= 0;
            downscaled_done <= '0';
            done <= '0';
        -- Main process
        elsif rising_edge(clk) then
            -- State machine
            case state is
                -- Idle state
                when IDLE =>
                    width <= input_width;
                    height <= input_height;
                    r_array <= image_input;
                    resolution <= (input_width / downscale_factor) * (input_height / downscale_factor);
                    downscaled_width <= input_width / downscale_factor;
                    downscaled_height <= input_height / downscale_factor;
                    state <= PROCESS_INPUT;
                -- Process input image
                when PROCESS_INPUT =>
                    state <= DOWNSCALE;
                -- Downscale image
                when DOWNSCALE =>
                    -- Cek apakah proses box sampling sudah selesai
                    if box_sampling_done = '1' then
                        -- Copy hasil downscaled image ke output image
                        for i in 0 to (height / downscale_factor) - 1 loop
                            for j in 0 to (width / downscale_factor) - 1 loop
                                output_image(j, i) <= downscaled_image(j, i);
                            end loop;
                        end loop;
                        downscaled_done <= '1';
                        done <= '1';
                        state <= IDLE; -- Kembali ke state idle
                    end if;
            end case;
        end if;
    end process;
end Structural;
