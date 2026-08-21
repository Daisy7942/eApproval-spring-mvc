-- 1. 부서 적재 (재직자 기준)
  INSERT INTO department (department_name)
  SELECT DISTINCT `부서`
  FROM stg_employee
  WHERE (`퇴직구분` IS NULL OR `퇴직구분` = '')
    AND `부서` IS NOT NULL AND `부서` <> '';

  -- 2. 팀 적재
  INSERT INTO team (team_name, department_id)
  SELECT DISTINCT s.`팀`, d.department_id
  FROM stg_employee s
  JOIN department d ON d.department_name = s.`부서`
  WHERE (s.`퇴직구분` IS NULL OR s.`퇴직구분` = '')
    AND s.`팀` IS NOT NULL AND s.`팀` <> '';

  -- 3. 사원 적재 (상급자 제외, 기존 계정은 정보만 갱신)
  INSERT INTO employee (employee_code, name, email,
  team_id, position, title, position_level, role)
  SELECT
    s.`사원번호`,
    s.`이름`,
    NULLIF(s.`이메일`, ''),
    t.team_id,
    NULLIF(s.`직급`, ''),
    NULLIF(s.`직책`, ''),
    CASE WHEN s.`직급레벨` REGEXP '^[0-9]+$' THEN
  CAST(s.`직급레벨` AS UNSIGNED) ELSE NULL END,
    'USER'
  FROM stg_employee s
  LEFT JOIN team t ON t.team_name = s.`팀`
  WHERE (s.`퇴직구분` IS NULL OR s.`퇴직구분` = '')
  ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    email = VALUES(email),
    team_id = VALUES(team_id),
    position = VALUES(position),
    title = VALUES(title),
    position_level = VALUES(position_level);

  -- 4. 상급자(manager_id) 채우기 (사원 전체 적재 후 2차 처리)
  UPDATE employee e
  JOIN stg_employee s ON e.employee_code =
  s.`사원번호`
  JOIN employee m ON m.employee_code =
  s.`직속상사사원번호`
  SET e.manager_id = m.employee_id;

  -- 5. 인사팀 소속 = 관리자 권한
  UPDATE employee e
  JOIN team t ON e.team_id = t.team_id
  SET e.role = 'ADMIN'
  WHERE t.team_name = '인사팀';

  -- 5-1. 사장·본부장도 관리자 권한 (전사 휴가 현황을 봐야 한다)
  --      '사장' 은 직급(position), '본부장' 은 직책(title) 칸에 들어 있다.
  UPDATE employee
  SET role = 'ADMIN'
  WHERE position = '사장' OR title = '본부장';