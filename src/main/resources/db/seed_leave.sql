UPDATE employee e
 JOIN stg_employee s ON e.employee_code = s.`사원번호`
  SET e.remain_leave = IFNULL(ROUND(s.`미사용휴가일수`, 1), 0);

-- 휴가 종류 마스터
-- description    : 화면 칩 밑에 뜨는 안내 문구
-- deduct_balance : 잔여연차를 깎는가 (연차만 1)
-- is_paid        : 유급인가
-- allow_half_day : 반차가 되는가
-- default_days   : 모두에게 같은 법정 부여일수.
--                  연차는 사람마다 달라서 NULL 이고 employee.remain_leave 를 쓴다.
INSERT INTO vacation_type
  (vacation_type_id, type_name, description,
   deduct_balance, is_paid, allow_half_day, default_days) VALUES
('ANNUAL',    '연차',
 '근로기준법상 부여되는 유급 휴가입니다. 잔여 연차에서 차감됩니다.',
 1, 1, 1, NULL),
('SICK',      '병가',
 '질병이나 부상으로 치료 및 휴식이 필요할 때 사용하는 휴가입니다. 승인 시 지급 (연차 차감 x, 증빙서류 필요)',
 0, 1, 0, NULL),
('EVENT',     '경조사',
 '본인 및 가족의 경조사(결혼, 출산, 사망 등) 발생 시 사용하는 유급휴가입니다. 승인 시 지급 (연차 차감 x, 증빙서류 필요)',
 0, 1, 0, NULL),
('OFFICIAL',  '공가',
 '예비군·민방위 훈련, 투표 등 법령상 공적 의무 이행 시 사용하는 유급휴가입니다. 승인 시 지급 (연차 차감 x, 증빙서류 필요)',
 0, 1, 0, NULL),
('MATERNITY', '출산휴가',
 '임신·출산으로 인한 체력 회복 및 건강 보호를 위한 유급휴가입니다. (최대 90일 / 결재 승인 시 자동 소진)',
 0, 1, 0, 90.0),
('SPOUSE',    '배우자 출산휴가',
 '배우자 출산 후 배우자와 태아의 건강 보호를 위한 유급휴가입니다. (최대 10일 / 결재 승인 시 자동 소진)',
 0, 1, 0, 10.0),
('COMP',      '보상휴가',
 '연장·야간·휴일 근로에 대한 임금을 대신하여 부여되는 유급휴가입니다. 승인 시 지급',
 0, 1, 1, NULL),
('FAMILY',    '가족돌봄',
 '질병·사고·양육 등으로 가족 돌봄이 필요할 때 신청하는 무급휴가입니다. (연 최대 10일 / 결재 승인 시 자동 소진)',
 0, 0, 0, 10.0);
