DELIMITER ;;

CREATE DEFINER='root'@'localhost'
    FUNCTION getDistanceMBR(p_origin POINT, p_distanceKm DOUBLE) RETURNS POLYGON DETERMINISTIC
    SQL SECURITY INVOKER
BEGIN
    DECLARE v_originLat DOUBLE DEFAULT 0.0;
    DECLARE v_originLon DOUBLE DEFAULT 0.0;
    
    DECLARE v_deltaLon DOUBLE DEFAULT 0.0;
    DECLARE v_Lat1 DOUBLE DEFAULT 0.0;
    DECLARE v_Lon1 DOUBLE DEFAULT 0.0;
    DECLARE v_Lat2 DOUBLE DEFAULT 0.0;
    DECLARE v_Lon2 DOUBLE DEFAULT 0.0;

    SET v_originLat = ST_X(p_origin); /* = ST_Latitude(p_origin) for SRID=4326*/
    SET v_originLon = ST_Y(p_origin); /* = ST_Longitude(p_origin) for SRID=4326 */

    SET v_deltaLon = p_distanceKm / ABS(COS(RADIANS(v_originLat))*111.32);
    SET v_Lon1 = v_originLon - v_deltaLon;
    SET v_Lon2 = v_originLon + v_deltaLon;
    SET v_Lat1 = v_originLat - (p_distanceKm / 111.32); 
    SET v_Lat2 = v_originLat + (p_distanceKm / 111.32);

    SET @mbr = ST_AsText(ST_Envelope(ST_GeomFromText(CONCAT("LINESTRING(", v_Lat1, " ", v_Lon1,", ", v_Lat2, " ", v_Lon2,")"))));
    RETURN ST_PolygonFromText(@mbr, ST_SRID(p_origin));
END ;;

DELIMITER ;
