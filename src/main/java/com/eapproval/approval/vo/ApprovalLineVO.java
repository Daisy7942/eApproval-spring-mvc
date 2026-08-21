package com.eapproval.approval.vo;

import java.time.LocalDateTime;

public class ApprovalLineVO {
	private Long approvalLineId; // 결재선 한 줄의 PK
	private Long docId; // 어느 문서의 결재선인지
	private Long approverId; // 결재자 (employee_id)
	private int approvalOrder; // 결재 순서 1,2,3
	private int round; // 반려 후 재상신 차수. 처음은 1
	private Long signatureId; // 결재하며 찍은 서명 이미지
	private String approvalType; // APPROVAL 결재 / AGREEMENT 합의
	private String approvalStatus; // PENDING 대기 / APPROVED 승인 / REJECTED 반려
	private String comment; // 결재 의견
	private LocalDateTime approvedAt; // 결재 처리 시각
	private String name;      // 결재자 이름
	private String position;  // 직급 (부장)
	private String teamName;  // 팀 이름

	public String getName() {
		return name;
	}

	public String getPosition() {
		return position;
	}

	public String getTeamName() {
		return teamName;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public void setTeamName(String teamName) {
		this.teamName = teamName;
	}

	public Long getApprovalLineId() {
		return approvalLineId;
	}

	public Long getDocId() {
		return docId;
	}

	public Long getApproverId() {
		return approverId;
	}

	public int getApprovalOrder() {
		return approvalOrder;
	}

	public int getRound() {
		return round;
	}

	public Long getSignatureId() {
		return signatureId;
	}

	public String getApprovalType() {
		return approvalType;
	}

	public String getApprovalStatus() {
		return approvalStatus;
	}

	public String getComment() {
		return comment;
	}

	public LocalDateTime getApprovedAt() {
		return approvedAt;
	}

	public void setApprovalLineId(Long approvalLineId) {
		this.approvalLineId = approvalLineId;
	}

	public void setDocId(Long docId) {
		this.docId = docId;
	}

	public void setApproverId(Long approverId) {
		this.approverId = approverId;
	}

	public void setApprovalOrder(int approvalOrder) {
		this.approvalOrder = approvalOrder;
	}

	public void setRound(int round) {
		this.round = round;
	}

	public void setSignatureId(Long signatureId) {
		this.signatureId = signatureId;
	}

	public void setApprovalType(String approvalType) {
		this.approvalType = approvalType;
	}

	public void setApprovalStatus(String approvalStatus) {
		this.approvalStatus = approvalStatus;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public void setApprovedAt(LocalDateTime approvedAt) {
		this.approvedAt = approvedAt;
	}
}
