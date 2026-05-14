import os
import torch
import torch.distributed as dist

def run(rank, size):
    # Initialize "fake" network using CPU-based GLOO
    dist.init_process_group(backend="gloo", rank=rank, world_size=size)
    
    # Create a tensor
    tensor = torch.ones(1) * rank
    
    # All-Reduce: Every "node" sends its number, they get summed up
    dist.all_reduce(tensor, op=dist.ReduceOp.SUM)
    
    print(f"I am Node {rank}. The total sum across all nodes is: {tensor.item()}")

if __name__ == "__main__":
    # In a real K8s cluster, these are set by the operator
    import sys
    rank = int(sys.argv[1]) # Pass 0 for first terminal, 1 for second
    size = 2                # Total number of "nodes"
    
    os.environ['MASTER_ADDR'] = '127.0.0.1'
    os.environ['MASTER_PORT'] = '29500'
    run(rank, size)
