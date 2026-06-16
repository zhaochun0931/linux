import redis
import time

def insert_one_million_entries():
    # Connect to your Docker Redis instance
    # If running inside the same Docker network, change 'localhost' to 'redis'
    r = redis.Redis(
        host='localhost', 
        port=6379, 
        password='password', 
        decode_responses=True
    )
    
    total_entries = 1_000_000
    chunk_size = 10_000  # Send 10k commands per batch to optimize memory use
    
    print(f"Starting insertion of {total_entries} entries using Pipelining...")
    start_time = time.time()
    
    # Initialize the pipeline
    pipe = r.pipeline(transaction=False) # transaction=False boosts speed significantly
    
    for i in range(1, total_entries + 1):
        # Format key-value pairs
        pipe.set(f"user:session:{i}", f"token_value_xyz_{i}")
        
        # Execute in chunks so we don't hog too much client-side RAM
        if i % chunk_size == 0:
            pipe.execute()
            if i % 100_000 == 0:
                print(f"Progress: {i}/{total_entries} entries inserted...")
                
    # Flush any remaining commands
    pipe.execute()
    
    end_time = time.time()
    elapsed = end_time - start_time
    print(f"\n Success! 1 million entries inserted in {elapsed:.2f} seconds.")
    print(f"Throughput: {int(total_entries / elapsed)} keys/second.")

if __name__ == "__main__":
    insert_one_million_entries()
