package com.eapproval.approval.vo;

import java.time.LocalDateTime;
import java.util.List;

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
    private List<ApprovalLineVO> approvalLine; 
    
	public List<ApprovalLineVO> getApprovalLine() {
		return approvalLine;
	}
	public void setApprovalLine(List<ApprovalLineVO> approvalLine) {
		this.approvalLine = approvalLine;
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

}
