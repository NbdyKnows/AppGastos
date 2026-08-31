import struct
import zlib
import os

def create_png(width, height, r, g, b, filename):
    png = b'\x89PNG\r\n\x1a\n'
    
    # IHDR chunk: 512x512, 8-bit RGB
    ihdr_data = struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0)
    ihdr_crc = struct.pack('>I', zlib.crc32(b'IHDR' + ihdr_data))
    png += struct.pack('>I', len(ihdr_data)) + b'IHDR' + ihdr_data + ihdr_crc
    
    # Raw scanlines: Filter type 0 + RGB * width
    raw_row = b'\x00' + bytes([r, g, b]) * width
    raw_data = raw_row * height
    
    # IDAT chunk
    compressed_data = zlib.compress(raw_data, level=9)
    idat_crc = struct.pack('>I', zlib.crc32(b'IDAT' + compressed_data))
    png += struct.pack('>I', len(compressed_data)) + b'IDAT' + compressed_data + idat_crc
    
    # IEND chunk
    iend_crc = struct.pack('>I', zlib.crc32(b'IEND'))
    png += struct.pack('>I', 0) + b'IEND' + iend_crc
    
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    with open(filename, 'wb') as f:
        f.write(png)

if __name__ == '__main__':
    create_png(512, 512, 0x0C, 0x18, 0x21, 'assets/icon.png')
    print('Generated assets/icon.png successfully')
