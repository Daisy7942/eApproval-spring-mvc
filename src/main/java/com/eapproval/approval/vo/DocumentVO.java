package com.eapproval.approval.vo;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

public class DocumentVO {

    private Long docId;              // 문서 번호 (PK)
    private String documentType;     // FREE, VACATION
    private String title;
    private String content;
    private Long employeeId;         // 기안자
    private String approvalType;     // SEQUENTIAL, PARALLEL
    private String status;           // DRAFT(임시저장), PENDING(결재 진행 중), APPROVED(승인), REJECTED(반려), WITHDRAWN(회수)
    private Boolean isUrgent;
    private Long draftSignatureId;
    private LocalDateTime signedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<ApprovalLineVO> approvalLine;   // 지금 돌고 있는 결재선 하나 (최신 차수)
    private List<ApprovalLineVO> history;        // 지난 차수까지 실제로 찍힌 결재 이력
    private String drafterName;
    private String drafterPosition;
    private String drafterTeam;
    private VacationRequestVO vacation;
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate dueDate;       // 결재 마감일 (선택. 없으면 NULL)
    
    
	public LocalDate getDueDate() {
		return dueDate;
	}
	public void setDueDate(LocalDate dueDate) {
		this.dueDate = dueDate;
	}
	public VacationRequestVO getVacation() {
		return vacation;
	}
	public void setVacation(VacationRequestVO vacation) {
		this.vacation = vacation;
	}
	public String getDrafterName() {
		return drafterName;
	}
	public String getDrafterPosition() {
		return drafterPosition;
	}
	public String getDrafterTeam() {
		return drafterTeam;
	}
	public void setDrafterName(String drafterName) {
		this.drafterName = drafterName;
	}
	public void setDrafterPosition(String drafterPosition) {
		this.drafterPosition = drafterPosition;
	}
	public void setDrafterTeam(String drafterTeam) {
		this.drafterTeam = drafterTeam;
	}
	public List<ApprovalLineVO> getApprovalLine() {
		return approvalLine;
	}
	public void setApprovalLine(List<ApprovalLineVO> approvalLine) {
		this.approvalLine = approvalLine;
	}
	public List<ApprovalLineVO> getHistory() {
		return history;
	}
	public void setHistory(List<ApprovalLineVO> history) {
		this.history = history;
	}
	public Long getDocId() {
		return docId;
	}
	public String getDocumentType() {
		return documentType;
	}
	public String getTitle() {
		return title;
	}
	public String getContent() {
		return content;
	}
	public Long getEmployeeId() {
		return employeeId;
	}
	public String getApprovalType() {
		return approvalType;
	}
	public String getStatus() {
		return status;
	}
	public Boolean getIsUrgent() {
		return isUrgent;
	}
	public Long getDraftSignatureId() {
		return draftSignatureId;
	}
	public LocalDateTime getSignedAt() {
		return signedAt;
	}
	public LocalDateTime getCreatedAt() {
		return createdAt;
	}
	public LocalDateTime getUpdatedAt() {
		return updatedAt;
	}
	public void setDocId(Long docId) {
		this.docId = docId;
	}
	public void setDocumentType(String documentType) {
		this.documentType = documentType;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public void setEmployeeId(Long employeeId) {
		this.employeeId = employeeId;
	}
	public void setApprovalType(String approvalType) {
		this.approvalType = approvalType;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public void setIsUrgent(Boolean isUrgent) {
		this.isUrgent = isUrgent;
	}
	public void setDraftSignatureId(Long draftSignatureId) {
		this.draftSignatureId = draftSignatureId;
	}
	public void setSignedAt(LocalDateTime signedAt) {
		this.signedAt = signedAt;
	}
	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}
	public void setUpdatedAt(LocalDateTime updatedAt) {
		this.updatedAt = updatedAt;
	}

	// 마감일이 지났는가. 색구별용.
	public boolean isOverdue() {
		return dueDate != null && dueDate.isBefore(LocalDate.now());
	}
	
	// 마감까지 남은 날수. 음수면 그만큼 지난 것
	public long getDaysLeft() {
		return dueDate == null ? 0 : java.time.temporal.ChronoUnit.DAYS.between(LocalDate.now(), dueDate);
	}
}


