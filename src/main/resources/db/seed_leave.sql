UPDATE employee e
 JOIN stg_employee s ON e.employee_code = s.`사원번호`
  SET e.remain_leave = IFNULL(ROUND(s.`미사용휴가일수`, 1), 0);

-- 휴가 종류 마스터
-- deduct_balance : 잔여연차를 깎는가 (연차만 1)
-- is_paid        : 유급인가
-- allow_half_day : 반차/반반차가 되는가
INSERT INTO vacation_type (vacation_type_id, type_name, deduct_balance, is_paid, allow_half_day) VALUES
('ANNUAL',    '연차',       1, 1, 1),
('SICK',      '병가',       0, 1, 0),
('EVENT',     '경조사',     0, 1, 0),
('OFFICIAL',  '공가',       0, 1, 0),
('MATERNITY', '출산휴가',   0, 1, 0),
('COMP',      '보상휴가',   0, 1, 1),
('FAMILY',    '가족돌봄',   0, 0, 0);
