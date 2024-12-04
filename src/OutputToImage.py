from PIL import Image

def create_image_from_output(output_file, image_path):
    with open(output_file, 'r') as file:
        lines = file.readlines()
    
    # Read resolution
    width = int(lines[0].strip())
    height = int(lines[1].strip())
    
    # Read RGB values
    pixels = []
    for line in lines[2:]:
        r, g, b = map(int, line.strip().split())
        pixels.append((r, g, b))
    
    # Create image
    img = Image.new('RGB', (width, height))
    img.putdata(pixels)
    img.save(image_path)

# Example usage:
output_file = 'Output.txt'  # Path to the output file
image_path = 'reconstructed_image.jpg'  # Path to save the reconstructed image
create_image_from_output(output_file, image_path)

print(f"Image saved as {image_path}")
