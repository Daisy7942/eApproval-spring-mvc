package com.eapproval.employee.vo;

public class OrgVO {
	private Long departmentId;  
	private String departmentName;
	private Long teamId;   
	private String teamName;
	private Long employeeId;
	private String employeeCode;
	private String name;
	private String position;  
	private Integer positionLevel;
	private String title;
	
	
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public Long getDepartmentId() {
		return departmentId;
	}
	public String getDepartmentName() {
		return departmentName;
	}
	public Long getTeamId() {
		return teamId;
	}
	public String getTeamName() {
		return teamName;
	}
	public Long getEmployeeId() {
		return employeeId;
	}
	public String getEmployeeCode() {
		return employeeCode;
	}
	public String getName() {
		return name;
	}
	public String getPosition() {
		return position;
	}
	public Integer getPositionLevel() {
		return positionLevel;
	}
	public void setDepartmentId(Long departmentId) {
		this.departmentId = departmentId;
	}
	public void setDepartmentName(String departmentName) {
		this.departmentName = departmentName;
	}
	public void setTeamId(Long teamId) {
		this.teamId = teamId;
	}
	public void setTeamName(String teamName) {
		this.teamName = teamName;
	}
	public void setEmployeeId(Long employeeId) {
		this.employeeId = employeeId;
	}
	public void setEmployeeCode(String employeeCode) {
		this.employeeCode = employeeCode;
	}
	public void setName(String name) {
		this.name = name;
	}
	public void setPosition(String position) {
		this.position = position;
	}
	public void setPositionLevel(Integer positionLevel) {
		this.positionLevel = positionLevel;
	}
	
	}
