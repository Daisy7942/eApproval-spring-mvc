package com.eapproval.web;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.eapproval.approval.dao.DocumentMapper;
import com.eapproval.approval.vo.DocumentVO;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath:spring/datasource.xml")
public class DocumentMapperTest {
	
	@Autowired
	private DocumentMapper documentMapper;
	
	@Test
	public void testInsert() {
        DocumentVO vo = new DocumentVO();
        vo.setDocumentType("FREE"); // 어떤 양식인가 , 자유형식, 휴가양식
        vo.setTitle("테스트 기안"); // 문서 제목, 8월 연차 신청
        vo.setContent("내용 테스트"); // 본문 내용
        vo.setEmployeeId(18L);         // 기안자
        vo.setApprovalType("SEQUENTIAL"); // 결재순서, 순차, 병렬
        vo.setStatus("DRAFT"); // 어떤 단계인가 , DRAFT(임시저장), PENDING(결재 진행중-결정대기) 
        vo.setIsUrgent(false); //긴급한가

        int result = documentMapper.insertDocument(vo);

        System.out.println("INSERT 건수: " + result);
        System.out.println("생성된 문서번호: " + vo.getDocId());
	}
}
