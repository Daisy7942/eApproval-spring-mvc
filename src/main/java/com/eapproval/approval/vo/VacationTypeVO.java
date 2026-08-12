package com.eapproval.approval.vo;

public class VacationTypeVO {

	private String vacationTypeId;
	private String typeName;
	private boolean deductBalance;
	private boolean isPaid;
	private boolean allowHalfDay;

	public String getVacationTypeId() {
		return vacationTypeId;
	}

	public String getTypeName() {
		return typeName;
	}

	public boolean isDeductBalance() {
		return deductBalance;
	}

	public boolean getIsPaid() {
		return isPaid;
	}

	public boolean isAllowHalfDay() {
		return allowHalfDay;
	}

	public void setVacationTypeId(String vacationTypeId) {
		this.vacationTypeId = vacationTypeId;
	}

	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}

	public void setDeductBalance(boolean deductBalance) {
		this.deductBalance = deductBalance;
	}

	public void setIsPaid(boolean isPaid) {
		this.isPaid = isPaid;
	}

	public void setAllowHalfDay(boolean allowHalfDay) {
		this.allowHalfDay = allowHalfDay;
	}

}
