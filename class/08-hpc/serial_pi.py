#!/usr/bin/env python3

import random
import logging
import sys
import pandas as pd

logging.basicConfig(level=logging.INFO)

def parse_args():
    """
    Parse command line arguments.
    """
    try:
        num_points = int(sys.argv[1])
        output_file = sys.argv[2]
    except ValueError:
        logging.error("Error: Number of points must be an integer")
        sys.exit(1)
    except IndexError:
        logging.error("Error: Number of points and output file must be provided")
        sys.exit(1)

    return num_points, output_file


def calculate_pi(num_points):
    """
    Calculate pi using the Monte Carlo method. We use an inefficient for loop on purpose to demonstrate the serial nature of the computation.
    """
    master = random.Random()
    seed = master.randint(0, 2**32 - 1)
    random.seed(seed)
    logging.info(f"Calculating pi using {num_points} points")
    num_inside = 0
    for _ in range(num_points):
        x = random.random()
        y = random.random()
        if x**2 + y**2 <= 1:
            num_inside += 1
    return 4 * num_inside / num_points

def save_result(pi, num_points, output_file):
    """
    Save the result to a CSV file.
    """
    df = pd.DataFrame({'pi': [pi], 'num_points': [num_points]})
    df.to_csv(output_file, index=False)

def main():
    """
    Main function.
    """
    num_points, output_file = parse_args()
    pi = calculate_pi(num_points)
    save_result(pi, num_points, output_file)
    logging.info(f"Pi: {pi}")
    logging.info(f"Saved result to {output_file}")

if __name__ == "__main__":
    main()