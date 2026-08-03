package com.eapproval.employee.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.eapproval.employee.dao.EmployeeMapper;
import com.eapproval.employee.vo.EapprovalVO;

@Service
public class LoginService {

	@Autowired
    private EmployeeMapper employeeMapper;

    /**
     * 사원 코드로 사원 정보(VO)를 조회
     * @param employeeCode 사원 코드
     * @return 사원 정보가 존재하면 EapprovalVO, 없으면 null 반환
     */
    public EapprovalVO getEmployee(String employeeCode) {
        return employeeMapper.selectUserById(employeeCode);
    }
}