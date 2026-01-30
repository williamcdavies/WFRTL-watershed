COPY (
WITH ws_filtered AS (
    SELECT
        ws.id
            AS id,
        ws.tnmid
            AS tnmid,
        ws.globalid
            AS globalid,
        ws.huc12
            AS huc12,
        ws.name
            AS name,
        ws.geom
            AS ws_geometry,
        fu.geometry 
            AS fu_geometry,
        ST_Intersection(ws.geom, fu.geometry) 
            AS intersection_geometry,
        ST_Area(ws.geom) AS area
    FROM 
        wbd_hu12 
            AS ws
    JOIN 
        public.fire_area_canada_usa_unions 
            AS fu 
                ON fu.year = {{YEAR}}
    WHERE ST_Intersects(ws.geom, fu.geometry)
)
SELECT
    id,
    tnmid,
    globalid,
    huc12,
    name,
    ST_Area(intersection_geometry) / NULLIF(area, 0) 
        AS overlap_percentage,
    (ST_Area(intersection_geometry) / NULLIF(area, 0) > 0) 
        AS overlap
FROM 
    ws_filtered
ORDER BY 
    overlap_percentage DESC
) TO STDOUT WITH CSV HEADER;