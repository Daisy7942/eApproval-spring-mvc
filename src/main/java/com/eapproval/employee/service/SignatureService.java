package com.eapproval.employee.service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.Base64;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.eapproval.employee.dao.SignatureMapper;
import com.eapproval.employee.vo.SignatureVO;

@Service
public class SignatureService {

	/**
	 * 서명 이미지가 쌓이는 폴더.
	 * SIGN_DIR: 이미지 저장 외부 경로 (사용자 홈 디렉토리 하위 eapproval-files/signature)
     * 프로젝트 안(webapp) 내부 저장 시 이클립스 재배포 때 파일이 삭제되는 문제 방지
	 */
	private static final String SIGN_DIR = System.getProperty("user.home") + File.separator + "eapproval-files"
			+ File.separator + "signature";

	// MAX_SIGNATURES: 직원 1인당 등록 가능한 최대 서명 수 (5개)
	public static final int MAX_SIGNATURES = 5;

	@Autowired
	private SignatureMapper signatureMapper;

	//내 서명 목록 조회
	public List<SignatureVO> getMySignatures(long empId) {
		return signatureMapper.selectByEmployee(empId);
	}


	// 현재 대표 서명 PK 조회. 없으면 null 이고 화면은 기본 도장상태
	public Long getActiveSignatureId(long empId) {
		SignatureVO active = signatureMapper.selectActive(empId);
		return (active == null) ? null : active.getSignatureId();
	}

	// 신규 서명 등록 및 즉시 대표 서명 설정
		// - 등록 개수 제한(5개) 검증 -> Base64 데코딩 -> 파일 생성/저장 -> DB INSERT -> 대표 서명 변경
		// - 전체 과정 중 오류 발생 시 트랜잭션 롤백 처리
	@Transactional
	public void addSignature(long empId, String imageData) {

		//등록 개수 초과 검증 (최대 5개)
		if (signatureMapper.selectByEmployee(empId).size() >= MAX_SIGNATURES) {
			throw new IllegalStateException("서명은 " + MAX_SIGNATURES + "개까지 등록할 수 있습니다.");
		}

		//Base64 문자열을 이미지 바이트 배열로 변환
		byte[] image = decode(imageData);
		
		// 고유한 파일명 생성
		String fileName = "sig_" + empId + "_" + System.currentTimeMillis() + ".png";
		writeFile(fileName, image);

		//DB에 서명 정보 저장
		SignatureVO signature = new SignatureVO();
		signature.setOwnerType("EMPLOYEE");
		signature.setEmployeeId(empId);
		signature.setImagePath(fileName);

		signatureMapper.insertSignature(signature);

		// 방금 새로 등록한 서명을 대표 서명으로 설정
		chooseSignature(empId, signature.getSignatureId());
	}



	// 대표 서명 변경 signatureId 가 null 이면 대표 없음 = 기본 도장
	// 기존 대표 서명 설정 전체 해제('N') 후, 선택한 서명을 대표('Y')로 변경
	@Transactional
	public void chooseSignature(long empId, Long signatureId) {

		signatureMapper.clearActive(empId); // 기존 대표 서명 비활성화

		if (signatureId != null) {
			signatureMapper.activate(empId, signatureId);
		}
	}

	// 서명 소프트 삭제 (Soft Delete)
	// - 이미지 파일이나 DB 행을 직접 지우지 않고 플래그만 변경 (과거 결재문서 서명 보존)
	public void removeSignature(long empId, long signatureId) {
		signatureMapper.markDeleted(empId, signatureId);
	}

	/** 화면에 이미지를 내려줄 때 쓴다. 파일이 없으면 null 을 돌려 404 로 처리하게 한다 */
	public byte[] readImage(long signatureId) {

		SignatureVO signature = signatureMapper.selectSignature(signatureId);
		if (signature == null) {
			return null;
		}

		File file = new File(SIGN_DIR, signature.getImagePath());
		if (!file.exists()) {
			return null;
		}

		try {
			return Files.readAllBytes(file.toPath());
		} catch (IOException e) {
			throw new IllegalStateException("서명 이미지를 읽지 못했습니다.", e);
		}
	}

	/**
	 * "data:image/png;base64,iVBORw0K..." 에서 쉼표 뒤만 잘라 바이트로 되돌린다.
	 * 앞부분은 브라우저가 붙인 꼬리표라 그대로 디코딩하면 깨진다.
	 */
	private byte[] decode(String imageData) {

		if (imageData == null || imageData.isEmpty()) {
			throw new IllegalArgumentException("서명 이미지가 비어 있습니다.");
		}

		// 쉼표(,) 기준 뒷부분(실제 바이너리 데이터)만 잘라내기
		int comma = imageData.indexOf(',');
		String body = (comma > -1) ? imageData.substring(comma + 1) : imageData;

		return Base64.getDecoder().decode(body);
	}

	//하드디스크에 파일 물리 저장 헬퍼 메서드 : 폴더가 없으면 만들고 쓴다
	private void writeFile(String fileName, byte[] image) {

		File dir = new File(SIGN_DIR);
		if (!dir.exists()) {
			dir.mkdirs(); // 하위 폴더까지 일괄 생성
		}

		try {
			Files.write(new File(dir, fileName).toPath(), image);
		} catch (IOException e) {
			throw new IllegalStateException("서명 이미지를 저장하지 못했습니다.", e);
		}
	}
}
