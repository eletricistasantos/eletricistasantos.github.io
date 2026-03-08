from PIL import Image
import numpy as np

try:
    img_path = r"C:\Users\Flavio Souza\.gemini\antigravity\scratch\EletricistaSantosWebsite\assets\logo.png"
    out_path = r"C:\Users\Flavio Souza\.gemini\antigravity\scratch\EletricistaSantosWebsite\assets\logo_black.png"
    
    img = Image.open(img_path).convert("RGBA")
    data = np.array(img)
    
    r, g, b, a = data[:,:,0], data[:,:,1], data[:,:,2], data[:,:,3]
    
    # We want to replace the white background and the gray grid with black.
    # Let's say if the pixel is mostly gray/white (diff between max and min color is small) and it's light
    max_c = np.max(data[:,:,:3], axis=2)
    min_c = np.min(data[:,:,:3], axis=2)
    diff = max_c - min_c
    
    # If it's light and lacks color saturation, it's the background/grid
    # The logo uses blue, cyan, purple which have high saturation.
    mask = (max_c > 180) & (diff < 30)
    
    data[mask, 0] = 0
    data[mask, 1] = 0
    data[mask, 2] = 0
    data[mask, 3] = 255
    
    # Also handle transparent pixels by making them black
    trans_mask = a < 100
    data[trans_mask, 0] = 0
    data[trans_mask, 1] = 0
    data[trans_mask, 2] = 0
    data[trans_mask, 3] = 255
    
    img_out = Image.fromarray(data)
    img_out.save(out_path)
    print("Image processed successfully.")
except Exception as e:
    import traceback
    traceback.print_exc()
