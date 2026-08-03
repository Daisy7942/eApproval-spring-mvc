UPDATE employee e
 JOIN stg_employee s ON e.employee_code = s.`사원번호`
  SET e.remain_leave = IFNULL(ROUND(s.`미사용휴가일수`, 1), 0);
  