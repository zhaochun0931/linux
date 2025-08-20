# memswap_demo.py
import time

blocks = []
block_size = 100 * 1024 * 1024   # 100 MB per block

print("Allocating memory in 100 MB chunks...")

for i in range(50):  # try to allocate ~5 GB
    try:
        blocks.append(bytearray(block_size))
        print(f"Allocated { (i+1) * 100 } MB")
        time.sleep(1)
    except MemoryError:
        print("MemoryError: system ran out of RAM!")
        break

print("Holding allocated memory for 5 minutes...")
time.sleep(300)
