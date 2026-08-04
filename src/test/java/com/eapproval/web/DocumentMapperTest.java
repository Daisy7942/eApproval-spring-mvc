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
        vo.setDocumentType("FREE");
        vo.setTitle("테스트 기안");
        vo.setContent("내용 테스트");
        vo.setEmployeeId(18L);         
        vo.setApprovalType("SEQUENTIAL");
        vo.setStatus("DRAFT");
        vo.setIsUrgent(false);

        int result = documentMapper.insertDocument(vo);

        System.out.println("INSERT 건수: " + result);
        System.out.println("생성된 문서번호: " + vo.getDocId());
	}
}
