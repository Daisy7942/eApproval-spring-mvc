package com.eapproval.approval.vo;

import java.math.BigDecimal;
import java.time.LocalDate;

import org.springframework.format.annotation.DateTimeFormat;

public class VacationRequestVO {
	private Long vacationId;
	private Long docId;
	private Long employeeId;
	private String vacationTypeId;
	@DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
	private LocalDate startDate;
	@DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
	private LocalDate endDate;
	private BigDecimal days;
	private String reason;
	private String startHalf;
	private String endHalf;
	
	public Long getVacationId() {
		return vacationId;
	}
	public Long getDocId() {
		return docId;
	}
	public Long getEmployeeId() {
		return employeeId;
	}
	public String getVacationTypeId() {
		return vacationTypeId;
	}
	public LocalDate getStartDate() {
		return startDate;
	}
	public LocalDate getEndDate() {
		return endDate;
	}
	public BigDecimal getDays() {
		return days;
	}
	public String getReason() {
		return reason;
	}
	public String getStartHalf() {
		return startHalf;
	}
	public String getEndHalf() {
		return endHalf;
	}
	public void setVacationId(Long vacationId) {
		this.vacationId = vacationId;
	}
	public void setDocId(Long docId) {
		this.docId = docId;
	}
	public void setEmployeeId(Long employeeId) {
		this.employeeId = employeeId;
	}
	public void setVacationTypeId(String vacationTypeId) {
		this.vacationTypeId = vacationTypeId;
	}
	public void setStartDate(LocalDate startDate) {
		this.startDate = startDate;
	}
	public void setEndDate(LocalDate endDate) {
		this.endDate = endDate;
	}
	public void setDays(BigDecimal days) {
		this.days = days;
	}
	public void setReason(String reason) {
		this.reason = reason;
	}
	public void setStartHalf(String startHalf) {
		this.startHalf = startHalf;
	}
	public void setEndHalf(String endHalf) {
		this.endHalf = endHalf;
	}
}
