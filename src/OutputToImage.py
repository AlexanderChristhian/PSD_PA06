# Code untuk mengonversi output dari program ke dalam bentuk gambar
from PIL import Image

## Fungsi untuk membuat gambar dari output
def create_image_from_output(output_file, image_path):
    with open(output_file, 'r') as file:
        lines = file.readlines()
    
    # Mengambil resolusi gambar
    width = int(lines[0].strip())
    height = int(lines[1].strip())
    
    # Mengambil nilai RGB dari setiap pixel
    pixels = []
    for line in lines[2:]:
        r, g, b = map(int, line.strip().split())
        pixels.append((r, g, b))
    
    # Membuat gambar dari nilai RGB
    img = Image.new('RGB', (width, height))
    img.putdata(pixels)
    img.save(image_path)

# Code untuk membuat gambar dari output
output_file = 'Output.txt'  
image_path = 'reconstructed_image.jpg' 
create_image_from_output(output_file, image_path)

print(f"Image saved as {image_path}")
