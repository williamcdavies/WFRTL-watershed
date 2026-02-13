#!/bin/bash

for year in $(seq 2024 -1 1984); do
    echo "Processing year $year …"

    # Script 1: compute lakes with overlap
    sed "s/{{YEAR}}/$year/g" q.sql | psql -d spatial -o "fire_area_canada_usa_composite${year}.csv"

    echo "Completed year $year."
done
