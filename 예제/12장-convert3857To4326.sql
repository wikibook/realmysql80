DELIMITER ;;

CREATE DEFINER='root'@'localhost'
    FUNCTION convert3857To4326(p_3857 POINT) RETURNS POINT
    DETERMINISTIC
    SQL SECURITY INVOKER
BEGIN
    DECLARE lon DOUBLE;
    DECLARE lat DOUBLE;
    DECLARE x DOUBLE;
    DECLARE y DOUBLE;

    /* Check SRID for the safety */
    IF ST_SRID(p_3857)=4326 THEN
      RETURN p_3857;
    ELSEIF ST_SRID(p_3857)<>3857 THEN
      SIGNAL SQLSTATE 'HY000' SET MYSQL_ERRNO=1108, MESSAGE_TEXT='Incorrect parameters (SRID must be 3857)';
    END IF;

    SET x = ST_X(p_3857);
    SET y = ST_Y(p_3857);

    /* 적도의 지구 둘레의 절반 = (2 * π * R)/2 = (π * EarthRadius) = (π * 6378137 meters) = 20037508.34 meters */
    SET lon = x *  180 / 20037508.34 ;
    SET lat = ATAN(EXP(y * PI() / 20037508.34)) * 360 / PI() - 90;

    RETURN ST_PointFromText(CONCAT('POINT(', lat,' ', lon,')'), 4326);
END ;;

DELIMITER ;
