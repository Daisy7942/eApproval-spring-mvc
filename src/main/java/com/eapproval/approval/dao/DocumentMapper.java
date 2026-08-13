package com.eapproval.approval.dao;

import java.math.BigDecimal;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.eapproval.approval.vo.ApprovalLineVO;
import com.eapproval.approval.vo.DocumentVO;
import com.eapproval.approval.vo.LeaveSummaryVO;
import com.eapproval.approval.vo.VacationRequestVO;
import com.eapproval.approval.vo.VacationTypeVO;

@Mapper
public interface DocumentMapper {
	// 저장
	int insertDocument(DocumentVO documentVO);

	// 임시저장 리스트 조회
	List<DocumentVO> selectDraftList(Long employeeId);

	// 임시저장 조회
	DocumentVO selectDraft(@Param("docId") Long docId, @Param("employeeId") Long employeeId);

	// 수정저장
	int updateDraft(DocumentVO documentVO);

	// 삭제
	int deleteDrafts(@Param("docIds") List<Long> docIds, @Param("employeeId") Long employeeId);

	// 결재선 여러건 저장
	void insertApprovalLines(@Param("lines") List<ApprovalLineVO> lines);

	// 상신 : status DRAFT → PENDING
	int submitDocument(DocumentVO documentVO);

	// 상신함 조회
	List<DocumentVO> selectSubmittedList(Long employeeId);

	// 결재 대기함 조회
	List<DocumentVO> selectPendingList(Long employeeId);

	// 완료함 조회
	List<DocumentVO> selectCompletedList(Long employeeId);

	// 문서 상세 조회
	DocumentVO selectDocumentDetail(@Param("docId") Long docId);

	// 내 결재선 줄 상태 바꾸기(승인·반려 공용)
	int updateApprovalStatus(@Param("docId") Long docId, @Param("approverId") Long approverId,
			@Param("approvalStatus") String approvalStatus, @Param("comment") String comment);

	// PENDING 개수 세기 - 이 숫자로 최종상태 반영을 위함 0일때 승인으로 처리
	int countPendingLines(@Param("docId") Long docId);

	// 문서 전체 상태 바꾸기(승인·반려 공용)
	int updateDocumentStatus(@Param("docId") Long docId, @Param("status") String status);
	
	// vacation 종류 칩 조회
	List<VacationTypeVO> selectVacationTypes();

	//휴가정보 저장
	void insertVacationRequest(VacationRequestVO vacation);
	
	// 잔여 연차 차감
	int deductLeave(@Param("employeeId") Long employeeId, @Param("days") BigDecimal days);
	
	// 연차 요약 (사용·대기 일수 집계)
	LeaveSummaryVO selectLeaveSummary(Long employeeId);
	
}
