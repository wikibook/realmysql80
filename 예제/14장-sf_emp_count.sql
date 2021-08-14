CREATE FUNCTION sf_emp_count(p_dept_no VARCHAR(10)) 
         RETURNS BIGINT
         DETERMINISTIC
         SQL SECURITY INVOKER
       BEGIN
         /* 사원 번호가 20000보다 큰 사원의 수를 누적하기 위한 변수 */
         DECLARE v_total_count INT DEFAULT 0;
         /* 커서에 더 읽어야 할 레코드가 남아 있는지 여부를 위한 플래그 변수 */ 
         DECLARE v_no_more_data TINYINT DEFAULT 0;
         /* 커서를 통해 SELECT된 사원 번호를 임시로 담아 둘 변수 */
         DECLARE v_emp_no INTEGER;
         /* 커서를 통해 SELECT된 사원의 입사 일자를 임시로 담아 둘 변수 */ 
         DECLARE v_from_date DATE;
         /* v_emp_list라는 이름으로 커서 정의 */ 
         DECLARE v_emp_list CURSOR FOR

         SELECT emp_no, from_date FROM dept_emp WHERE dept_no=p_dept_no;
         /* 커서로부터 더 읽을 데이터가 있는지를 나타내는 플래그 변경을 위한 핸들러 */ 
         DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_no_more_data = 1;

         /* 정의된 v_emp_list 커서를 오픈 */ 
         OPEN v_emp_list;
         REPEAT
           /* 커서로부터 레코드를 한 개씩 읽어서 변수에 저장 */ 
           FETCH v_emp_list INTO v_emp_no, v_from_date;
           IF v_emp_no > 20000 THEN
             SET v_total_count = v_total_count + 1; 
           END IF;
         UNTIL v_no_more_data END REPEAT;

         /* v_emp_list 커서를 닫고 관련 자원을 반납 */ 
         CLOSE v_emp_list;

         RETURN v_total_count; 
       END ;;
