DELIMITER ;;

CREATE DEFINER='root'@'localhost'
    FUNCTION convert4326To3857(p_4326 POINT) RETURNS POINT
    DETERMINISTIC
    SQL SECURITY INVOKER
BEGIN
    DECLARE lon DOUBLE;
    DECLARE lat DOUBLE;
    DECLARE x DOUBLE;
    DECLARE y DOUBLE;

    /* Check SRID for the safety */
    IF ST_SRID(p_4326)=3857 THEN
      RETURN p_4326;
    ELSEIF ST_SRID(p_4326)<>4326 THEN
      SIGNAL SQLSTATE 'HY000' SET MYSQL_ERRNO=1108, MESSAGE_TEXT='Incorrect parameters (SRID must be 4326)';
    END IF;

    SET lon = ST_Longitude(p_4326);
    SET lat = ST_Latitude(p_4326);

    /* 적도의 지구 둘레의 절반 = (2 * π * R)/2 = (π * EarthRadius) = (π * 6378137 meters) = 20037508.34 meters */
    SET x = lon * 20037508.34 / 180;
    SET y = LOG(TAN((90 + lat) * PI() / 360)) / (PI() / 180);
    SET y = y * 20037508.34 / 180;

    RETURN ST_PointFromText(CONCAT('POINT(', x,' ', y,')'), 3857);
END ;;

DELIMITER ;
