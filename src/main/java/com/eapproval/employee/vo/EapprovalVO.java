package com.eapproval.employee.vo;

public class EapprovalVO {

	private int employeeId;
	private String employeeCode;
	private String name;
    private String email;
    
    
	public int getEmployeeId() {
		return employeeId;
	}
	public String getEmployeeCode() {
		return employeeCode;
	}
	public String getName() {
		return name;
	}
	public String getEmail() {
		return email;
	}
	
	
	
	public void setEmployeeId(int employeeId) {
		this.employeeId = employeeId;
	}
	public void setEmployeeCode(String employeeCode) {
		this.employeeCode = employeeCode;
	}
	public void setName(String name) {
		this.name = name;
	}
	public void setEmail(String email) {
		this.email = email;
	}

}


