package com.eapproval.approval.vo;

import java.math.BigDecimal;

public class LeaveSummaryVO {
	private BigDecimal totalDays;    // 총 부여 = 잔여 + 사용
	private BigDecimal usedDays;     // 사용 (승인됨)
	private BigDecimal pendingDays;  // 승인 대기
	private BigDecimal remainDays;   // 잔여 = employee.remain_leave
	
	public BigDecimal getTotalDays() {
		return totalDays;
	}
	public BigDecimal getUsedDays() {
		return usedDays;
	}
	public BigDecimal getPendingDays() {
		return pendingDays;
	}
	public BigDecimal getRemainDays() {
		return remainDays;
	}
	public void setTotalDays(BigDecimal totalDays) {
		this.totalDays = totalDays;
	}
	public void setUsedDays(BigDecimal usedDays) {
		this.usedDays = usedDays;
	}
	public void setPendingDays(BigDecimal pendingDays) {
		this.pendingDays = pendingDays;
	}
	public void setRemainDays(BigDecimal remainDays) {
		this.remainDays = remainDays;
	}
}
