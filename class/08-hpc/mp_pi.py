#!/usr/bin/env python3

"""
Monte Carlo pi estimation using multiprocessing.
Usage: python mp_pi.py <num_points> <output_file> <num_processes>
"""

import random
import logging
import sys
import pandas as pd
from multiprocessing import Pool

logging.basicConfig(level=logging.INFO)


def parse_args():
    """
    Parse command line arguments.
    """
    try:
        num_points = int(sys.argv[1])
        output_file = sys.argv[2]
        num_processes = int(sys.argv[3])
    except ValueError:
        logging.error("Error: num_points and num_processes must be integers")
        sys.exit(1)
    except IndexError:
        logging.error("Usage: python %s <num_points> <output_file> <num_processes>",
                      sys.argv[0])
        sys.exit(1)
    if num_processes < 1:
        logging.error("Error: num_processes must be at least 1")
        sys.exit(1)
    return num_points, output_file, num_processes


def count_inside(args):
    """
    Worker: generate n_points random (x,y) and return how many fall inside unit circle.
    args = (n_points, base_seed, worker_id) so each worker has distinct RNG state.
    """
    n_points, base_seed, worker_id = args
    random.seed(base_seed + worker_id)
    num_inside = 0
    for _ in range(n_points):
        x = random.random()
        y = random.random()
        if x * x + y * y <= 1.0:
            num_inside += 1
    logging.info(f"Worker {worker_id}: {num_inside} points of {n_points} points inside are within the unit circle")
    return num_inside


def calculate_pi(num_points, num_processes):
    """
    Distribute num_points across num_processes workers; sum inside counts and compute pi.
    """
    logging.info(f"Calculating pi using {num_points} points and {num_processes} processes")
    master = random.Random()
    base_seed = master.randint(0, 2**32 - 1)
    # distribute the numpoints across the workers
    chunk_size = num_points // num_processes
    remainder = num_points % num_processes
    chunks = []
    for i in range(num_processes):
        n = chunk_size + (1 if i < remainder else 0)
        if n > 0:
            chunks.append((n, base_seed, i))
    logging.info(f"Chunks: {chunks}")

    # create a pool of workers and map the count_inside function to the chunks
    # counts is a list of results returned by each worker
    with Pool(processes=num_processes) as pool:
        counts = pool.map(count_inside, chunks)
    
    # aggregate the results
    total_inside = sum(counts)
    return 4.0 * total_inside / num_points


def save_result(pi, num_points, output_file):
    df = pd.DataFrame({"pi": [pi], "num_points": [num_points]})
    df.to_csv(output_file, index=False)


def main():
    num_points, output_file, num_processes = parse_args()
    pi = calculate_pi(num_points, num_processes)
    save_result(pi, num_points, output_file)
    logging.info(f"Pi: {pi}")
    logging.info(f"Saved result to {output_file}")


if __name__ == "__main__":
    main()
