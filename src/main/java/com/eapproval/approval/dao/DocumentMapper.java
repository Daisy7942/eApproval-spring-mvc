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
import com.eapproval.common.vo.PageVO;

@Mapper
public interface DocumentMapper {
	// 문서 저장
	int insertDocument(DocumentVO documentVO);

	// 임시저장 목록 조회.
	// 페이지·검색·필터 조건은 PageVO 하나에 다 들어 있다
	List<DocumentVO> selectDraftList(@Param("employeeId") Long employeeId,
			@Param("p") PageVO p);

	// 임시저장 전체 건수 (페이지 수 계산용)
	int countDrafts(@Param("employeeId") Long employeeId, @Param("p") PageVO p);

	// 임시저장 조회
	DocumentVO selectDraft(@Param("docId") Long docId, @Param("employeeId") Long employeeId);

	// 수정저장
	int updateDraft(DocumentVO documentVO);

	// 삭제
	int deleteDrafts(@Param("docIds") List<Long> docIds, @Param("employeeId") Long employeeId);

	// 임시저장 문서 삭제 시 관련 결재선 전체 삭제 (FK 제약조건 방지)
	int deleteDraftApprovalLines(@Param("docIds") List<Long> docIds,
			@Param("employeeId") Long employeeId);
	// 임시저장 문서 삭제 시 관련 휴가 신청 정보 삭제 (FK 제약조건 방지)
	int deleteDraftVacations(@Param("docIds") List<Long> docIds,
			@Param("employeeId") Long employeeId);

	// 임시저장 결재선 삭제 (지금 쓰는 차수만. 지난 차수는 이력이라 노터치)
	int deleteApprovalLines(@Param("docId") Long docId, @Param("employeeId") Long employeeId,
			@Param("round") int round);

	// 결재선의 마지막 차수 ( 결재선 미존재 시 null )
	Integer selectMaxRound(@Param("docId") Long docId);

	// 해당 차수의 결재 완료(승인·반려·취소) 건수 조회
	int countDoneLines(@Param("docId") Long docId, @Param("round") int round);

	// 임시저장 휴가정보 삭제
	int deleteVacationRequest(@Param("docId") Long docId, @Param("employeeId") Long employeeId);

	// 결재선 여러건 저장
	void insertApprovalLines(@Param("lines") List<ApprovalLineVO> lines);

	// 상신 : status DRAFT → PENDING
	int submitDocument(DocumentVO documentVO);
	
	// 상신 취소 : status PENDING → DRAFT (아무도 결재 안 했을 때만)
	int cancelSubmission(@Param("docId") Long docId, @Param("employeeId") Long employeeId);

	// 결재 이력 : 지난 차수까지 전부. 도장이 찍힌 줄만
	List<ApprovalLineVO> selectApprovalHistory(@Param("docId") Long docId);

	// 상신함 조회. PageVO.all() 을 주면 자르지 않고 전부 가져온다
	List<DocumentVO> selectSubmittedList(@Param("employeeId") Long employeeId,
			@Param("p") PageVO p);

	// 상신함 전체 건수
	int countSubmitted(@Param("employeeId") Long employeeId, @Param("p") PageVO p);

	// 결재 대기함 조회
	List<DocumentVO> selectPendingList(@Param("employeeId") Long employeeId,
			@Param("p") PageVO p);

	// 결재 대기함 전체 건수
	int countPending(@Param("employeeId") Long employeeId, @Param("p") PageVO p);

	// 완료함 조회
	List<DocumentVO> selectCompletedList(@Param("employeeId") Long employeeId,
			@Param("p") PageVO p);

	// 완료함 전체 건수
	int countCompleted(@Param("employeeId") Long employeeId, @Param("p") PageVO p);

	// 문서 상세 조회
	DocumentVO selectDocumentDetail(@Param("docId") Long docId);

	// 내 결재선 줄 상태 바꾸기(승인·반려 공용)
	int updateApprovalStatus(@Param("docId") Long docId, @Param("approverId") Long approverId,
			@Param("approvalStatus") String approvalStatus, @Param("comment") String comment);

	// PENDING 개수 세기 - 이 숫자로 최종상태 반영을 위함 0일때 승인으로 처리
	int countPendingLines(@Param("docId") Long docId);

	// 반려된 문서의 남은 대기 결재선 취소
	int cancelRemainingLines(@Param("docId") Long docId);

	// 문서 전체 상태 바꾸기(승인·반려 공용)
	int updateDocumentStatus(@Param("docId") Long docId, @Param("status") String status);

	// vacation 종류 칩 조회
	List<VacationTypeVO> selectVacationTypes();

	// 휴가정보 저장
	void insertVacationRequest(VacationRequestVO vacation);

	// 잔여 연차 차감
	int deductLeave(@Param("employeeId") Long employeeId, @Param("days") BigDecimal days);

	// 연차 요약 (사용·대기 일수 집계)
	LeaveSummaryVO selectLeaveSummary(Long employeeId);

	// 휴가신청 내역 목록
	List<VacationRequestVO> selectMyLeaveList(Long employeeId);

	// 휴가신청 종류 조회
	VacationTypeVO selectVacationType(String vacationTypeId);

}
