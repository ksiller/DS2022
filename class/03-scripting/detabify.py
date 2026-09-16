#!/usr/bin/env python

import io
import re

def convert(file_name):
    # Open csv file

    csv = io.open(file_name + ".csv", mode="w", encoding="utf-8")

    # Convert file_name.tsv to file_name.csv
    with io.open(file_name + ".tsv", mode="r", encoding="utf-8") as tsv:
        for line in tsv:
            csv.write(re.sub('\t',',',re.sub('(^|[\t])([^\t]*\,[^\t\n]*)', r'\1"\2"', line)))

    csv.close()

if __name__ == '__main__':
    print('Start converting ...')
    convert('new_mock_data')
    print('Converted!')
