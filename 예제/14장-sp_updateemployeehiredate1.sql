CREATE PROCEDURE sp_updateemployeehiredate1()
         DETERMINISTIC
         SQL SECURITY INVOKER
       BEGIN
         -- // 첫 번째 커서로부터 읽은 부서 번호를 저장 
         DECLARE v_dept_no CHAR(4);
         -- // 커서를 끝까지 읽었는지를 나타내는 플래그를 저장 
         DECLARE v_no_more_depts BOOLEAN DEFAULT FALSE;
         -- // 부서 정보를 읽는 첫 번째 커서 
         DECLARE v_dept_list CURSOR FOR SELECT dept_no FROM departments;
         -- // 부서 커서의 레코드를 끝까지 다 읽은 경우에 대한 핸들러 
         DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_no_more_depts := TRUE;
       
         OPEN v_dept_list;
         LOOP_OUTER: LOOP                    -- // 외부 루프 시작
           FETCH v_dept_list INTO v_dept_no;
           IF v_no_more_depts THEN 
              -- // 레코드를 모두 읽었으면 커서 종료 및 외부 루프 종료
             CLOSE v_dept_list;
             LEAVE loop_outer; 
           END IF;
       
           BLOCK_INNER: BEGIN -- // 내부 프로시저 블록 시작
             -- // -----------------------------------------------------------------
             -- // 두 번째 커서로부터 읽은 사원 번호 저장 
             DECLARE v_emp_no INT;
             -- // 사원 커서를 끝까지 읽었는지 여부를 위한 플래그 저장 
             DECLARE v_no_more_employees BOOLEAN DEFAULT FALSE;
             -- // 부서별 사원 1명을 읽는 두 번째 커서 
             DECLARE v_emp_list CURSOR FOR SELECT emp_no 
                                           FROM dept_emp 
                                           WHERE dept_no=v_dept_no LIMIT 1;
             -- // 사원 커서의 레코드를 끝까지 다 읽은 경우에 대한 핸들러
             DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_no_more_employees := TRUE;

             OPEN v_emp_list;
             LOOP_INNER: LOOP              -- // 내부 루프 시작
               FETCH v_emp_list INTO v_emp_no;
               -- // 레코드를 모두 읽었으면 커서 종료 및 내부 루프를 종료 
               IF v_no_more_employees THEN
                 CLOSE v_emp_list;
                 LEAVE loop_inner; 
               END IF;
             END LOOP loop_inner;          -- // 내부 루프 종료
           -- // ----------------------------------------------------------------- 
           END block_inner;                -- // 내부 프로시저 블록 종료
         END LOOP loop_outer;              -- // 외부 루프 종료 
       END;;
