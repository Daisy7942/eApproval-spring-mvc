package com.eapproval.web;

import static org.junit.Assert.assertNotNull; // DB 연결 검증 도구
import java.sql.Connection;
import javax.sql.DataSource;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

//스프링 테스트 환경 실행
@RunWith(SpringJUnit4ClassRunner.class)
//DB 설정파일 로드
@ContextConfiguration(locations ="classpath:spring/datasource.xml")
public class DataSourceTest{

	@Autowired // DB 접속 객체 자동 주입
	private DataSource clsDS;

	@Test
	public void testConnect() throws Exception {

		System.out.println( "Start" );

		// DB 연결 시도 (완료 후 자동 종료)
		try( Connection clsCon = clsDS.getConnection() ){

			System.out.println( "connected" );
			assertNotNull(clsCon); // 연결 성공 여부 검증 (null이 아니면 성공)
		}
	}

}