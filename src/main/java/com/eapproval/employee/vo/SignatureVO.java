package com.eapproval.employee.vo;

/**
 * signature 테이블 한 행.
 *
 * imagePath 에는 절대경로가 아니라 파일 이름만 담는다.
 * 폴더 위치가 바뀌어도 이미 저장된 행을 고치지 않기 위함이다.
 */
public class SignatureVO {

	private Long signatureId;
	private String ownerType; // EMPLOYEE (나중에 부서 직인 같은 게 생기면 늘어난다)
	private Long employeeId;
	private String imagePath; // 파일 이름만. 예) sig_1001_1723957200000.png
	private String isActive; // Y 한 행이 지금 결재에 찍히는 대표 서명
	private String isDeleted; // Y 면 목록에서 뺀다. 행과 파일은 남는다
	private String createdAt;

	public Long getSignatureId() {
		return signatureId;
	}

	public void setSignatureId(Long signatureId) {
		this.signatureId = signatureId;
	}

	public String getOwnerType() {
		return ownerType;
	}

	public void setOwnerType(String ownerType) {
		this.ownerType = ownerType;
	}

	public Long getEmployeeId() {
		return employeeId;
	}

	public void setEmployeeId(Long employeeId) {
		this.employeeId = employeeId;
	}

	public String getImagePath() {
		return imagePath;
	}

	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}

	public String getIsActive() {
		return isActive;
	}

	public void setIsActive(String isActive) {
		this.isActive = isActive;
	}

	public String getIsDeleted() {
		return isDeleted;
	}

	public void setIsDeleted(String isDeleted) {
		this.isDeleted = isDeleted;
	}

	public String getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}
}
