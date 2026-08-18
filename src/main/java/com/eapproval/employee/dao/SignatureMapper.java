package com.eapproval.employee.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.eapproval.employee.vo.SignatureVO;

@Mapper
public interface SignatureMapper {

	// 서명 등록 화면 목록. 지운 것은 빼고 최신순
	List<SignatureVO> selectByEmployee(long employeeId);

	// 지금 대표로 정해진 서명 한 행 (없으면 null = 기본 도장)
	SignatureVO selectActive(long employeeId);

	// 이미지 내려줄 때 파일 이름을 얻는 용도
	SignatureVO selectSignature(long signatureId);

	// 신규 서명 등록
	int insertSignature(SignatureVO signature);

	// 대표를 바꾸기 전에 내 것 전부 'N' 으로 내린다
	int clearActive(long employeeId);

	// 특정 서명을 대표 서명으로 지정 (is_active = 'Y' / 본인 소유 검증)
	int activate(@Param("employeeId") long employeeId, @Param("signatureId") long signatureId);

	// 행을 지우지 않고 표시만 바꾼다 (결재된 문서의 도장 보존)
	int markDeleted(@Param("employeeId") long employeeId, @Param("signatureId") long signatureId);
}
