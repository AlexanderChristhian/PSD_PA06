from PIL import Image
import os

# The code reads the RGB values of each pixel from left to right and then downwards. 
# The pixels are stored in a list, where each pixel is represented as a tuple (R, G, B).
def save_resolution_and_rgb_for_vhdl(image_path, output_file):
    if not os.path.exists(image_path):
        print(f"Image file {image_path} does not exist.")
        return

    with Image.open(image_path) as img:
        width, height = img.size
        img_rgb = img.convert("RGB")
        pixels = list(img_rgb.getdata())

    with open(output_file, 'w') as file:
        # Write resolution
        file.write(f"{width}\n")
        file.write(f"{height}\n")
        
        # Write RGB values for each pixel
        for pixel in pixels:
            file.write(f"{pixel[0]} {pixel[1]} {pixel[2]}\n")

# Example usage:
image_path = 'TestImage.jpg'  # Replace with your image path
output_file = 'image_for_vhdl.txt'  # Path to the output file
save_resolution_and_rgb_for_vhdl(image_path, output_file)

print(f"File saved as {output_file}")
