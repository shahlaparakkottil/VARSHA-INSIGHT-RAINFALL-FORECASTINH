#!/usr/bin/env python3

import sys

for line in sys.stdin:
    line = line.strip()

    if line.startswith("SUBDIVISION"):
        continue

    data = line.split(",")

    try:
        subdivision = data[0]
        annual_rainfall = float(data[14])
        print(f"{subdivision}\t{annual_rainfall}")

    except:
        continue