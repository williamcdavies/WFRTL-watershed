#!/bin/bash

for year in $(seq 2024 -1 1984); do
    echo "Processing year $year …"

    # Script 1: compute lakes with overlap
    sed "s/{{YEAR}}/$year/g" q.true.sql | psql -d spatial -o "fire_area_canada_usa_composite${year}_overlap_true.csv"

    # Script 2: compute lakes without overlap
    sed "s/{{YEAR}}/$year/g" q.false.sql | psql -d spatial -o "fire_area_canada_usa_composite${year}_overlap_false.csv"

    # Concatenate with TRUE rows first
    cat "fire_area_canada_usa_composite${year}_overlap_true.csv" \
        "fire_area_canada_usa_composite${year}_overlap_false.csv" \
        > "fire_area_canada_usa_composite${year}.csv"

    echo "Completed year $year."
done
