CREATE FUNCTION sf_divide (p_dividend INT, p_divisor INT) 
         RETURNS INT
         DETERMINISTIC
         SQL SECURITY INVOKER
       BEGIN
         DECLARE null_divisor CONDITION FOR SQLSTATE '45000';
         
         IF p_divisor IS NULL THEN
           SIGNAL null_divisor 
               SET MESSAGE_TEXT='Divisor can not be null', MYSQL_ERRNO=9999;
         ELSEIF p_divisor=0 THEN
           SIGNAL SQLSTATE '45000' 
               SET MESSAGE_TEXT='Divisor can not be 0', MYSQL_ERRNO=9998;
         ELSEIF p_dividend IS NULL THEN
           SIGNAL SQLSTATE '01000' 
               SET MESSAGE_TEXT='Dividend is null, so regarding dividend as 0', MYSQL_ERRNO=9997; 
           RETURN 0;
         END IF;
         
         RETURN FLOOR(p_dividend / p_divisor); 
       END;;
