CREATE TEMP TABLE fire_area_canada_usa_composite{{YEAR}} (
    id                 text,
    tnmid              text,
    globalid           text,
    huc12              text,
    name               text,
    overlap_percentage double precision,
    overlap            boolean
);

\copy fire_area_canada_usa_composite{{YEAR}} FROM '/Users/williamchuter-davies/Downloads/UNR WF FIRE_UNION_POLY_OVER_WATERSHEDS_POLYS_DATA-selected/fire_area_canada_usa_composite{{YEAR}}.csv' CSV HEADER;

COPY (
    SELECT
        x.id,
        x.tnmid,
        x.globalid,
        x.huc12,
        x.name,
        x.overlap_percentage,
        x.overlap,
        l."Hylak_id"  
            AS hylak_id,
        l."Lake_name" 
            AS lake_name
    FROM fire_area_canada_usa_composite{{YEAR}} 
        AS x
    JOIN wbd_hu12 
        AS ws
            ON ws.huc12 = x.huc12
    JOIN lakes_points 
        AS lp
            ON ST_Intersects(ST_Transform(ws.geom, 4326), lp.geometry)
    JOIN lakes 
        AS l
            ON l."Hylak_id" = lp."Hylak_id"
    WHERE x.overlap
    ORDER BY 
        x.id, 
        l."Hylak_id"
) TO STDOUT WITH CSV HEADER;