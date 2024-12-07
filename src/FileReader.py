# Code untuk membaca resolusi dan nilai RGB dari gambar dan menyimpannya ke dalam file teks
from PIL import Image
import os

# Fungsi untuk menyimpan resolusi dan nilai RGB dari gambar ke dalam file teks
def save_resolution_and_rgb_for_vhdl(image_path, output_file):
    if not os.path.exists(image_path):
        print(f"Image file {image_path} does not exist.")
        return

    # Buka gambar dan ambil resolusi dan nilai RGB dari setiap pixel
    with Image.open(image_path) as img:
        width, height = img.size
        img_rgb = img.convert("RGB")
        pixels = list(img_rgb.getdata())

    with open(output_file, 'w') as file:
        # Menyimpan resolusi gambar ke dalam file
        file.write(f"{width}\n")
        file.write(f"{height}\n")
        # Menginput downscale value
        downscale_value = int(input("Enter DownscaleValue: "))
        
        # Menulis downscale value ke dalam file
        file.write(f"{downscale_value}\n")
        
        # Menulis nilai RGB dari setiap pixel ke dalam file
        for pixel in pixels:
            file.write(f"{pixel[0]} {pixel[1]} {pixel[2]}\n")

# Code untuk membuat file teks dari resolusi dan nilai RGB dari gambar
image_path = 'TestContoh.jpg'  
output_file = 'image_for_vhdl.txt'  
save_resolution_and_rgb_for_vhdl(image_path, output_file)

print(f"File saved as {output_file}")
