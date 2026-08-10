package com.eapproval.employee.vo;

public class EapprovalVO {

	private int employeeId;
	private String employeeCode;
	private String name;
    private String email;
    private String role;
    private String teamName;
    private String departmentName;
    private String position;
    private String title;
    
	public String getTeamName() {
		return teamName;
	}
	public String getDepartmentName() {
		return departmentName;
	}
	public String getPosition() {
		return position;
	}
	public String getTitle() {
		return title;
	}
	public void setTeamName(String teamName) {
		this.teamName = teamName;
	}
	public void setDepartmentName(String departmentName) {
		this.departmentName = departmentName;
	}
	public void setPosition(String position) {
		this.position = position;
	}
	public void setTitle(String title) {
		this.title = title;
	}
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
	public String getRole() {
		return role;
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
	public void setRole(String role) {
		this.role = role;
	}
	
}


