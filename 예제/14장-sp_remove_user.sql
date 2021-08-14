CREATE PROCEDURE sp_remove_user (IN p_userid INT) 
         DETERMINISTIC
         SQL SECURITY INVOKER
       BEGIN
         DECLARE v_affectedrowcount INT DEFAULT 0;
         DECLARE EXIT HANDLER FOR SQLEXCEPTION
           BEGIN
             SIGNAL SQLSTATE '45000'
               SET MESSAGE_TEXT='Can not remove user information', MYSQL_ERRNO=9999;
           END;

         -- // 사용자의 정보를 삭제
         DELETE FROM tb_user WHERE user_id=p_userid;
         -- // 위에서 실행된 DELETE 쿼리로 삭제된 레코드 건수를 확인 
         SELECT ROW_COUNT() INTO v_affectedrowcount;
         -- // 삭제된 레코드 건수가 1건이 아닌 경우에는 에러 발생 
         IF v_affectedrowcount<>1 THEN
           SIGNAL SQLSTATE '45000'; 
         END IF;
       END;;
