#!/usr/bin/env python3

import sys

current_subdivision = None
total_rainfall = 0
count = 0

for line in sys.stdin:

    subdivision, rainfall = line.strip().split("\t")
    rainfall = float(rainfall)

    if current_subdivision == subdivision:
        total_rainfall += rainfall
        count += 1

    else:

        if current_subdivision:
            average = total_rainfall / count
            print(f"{current_subdivision}\t{average:.2f}")

        current_subdivision = subdivision
        total_rainfall = rainfall
        count = 1

if current_subdivision:
    average = total_rainfall / count
    print(f"{current_subdivision}\t{average:.2f}")