package com.eapproval.common.util;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.safety.Safelist;

//[보안 처리] 화면에서 들어온 값에서 위험한 코드를 걸러내는 유틸리티 클래스
public class HtmlSanitizer {

	// 본문에서 지우지 않고 남겨둘 안전한 태그 목록
	private static final Safelist BODY = Safelist.relaxed()
			// 글자색, 정렬 등 에디터 서식을 위해 style 속성 허용
			.addAttributes(":all", "style")
			// 에디터에 붙여넣은 이미지(data:image/...)를 보여주기 위해 data 프로토콜 허용
			.addProtocols("img", "src", "data")
			// 구분선(<hr>) 태그 허용
			.addTags("hr");

	private HtmlSanitizer() {
		// 유틸리티 클래스이므로 객체 생성을 막음
	}

	// Jsoup이 줄바꿈을 멋대로 띄어쓰기로 합쳐버리지 않도록 설정
	// (이걸 안 끄면 여러 줄로 쓴 글이 한 줄로 붙어버린다)
	private static Document.OutputSettings keepNewLines() {
		return new Document.OutputSettings().prettyPrint(false);
	}

	// [본문용] 글자색, 굵게 같은 서식은 남기고, 위험한 스크립트만 제거
	public static String cleanBody(String html) {
		if (html == null) {
			return null;
		}
		return Jsoup.clean(html, "", BODY, keepNewLines());
	}

	// [제목/사유/의견용] 서식이 필요 없는 텍스트이므로 모든 HTML 태그를 싹 지운다
	public static String cleanText(String text) {
		if (text == null) {
			return null;
		}
		return Jsoup.clean(text, "", Safelist.none(), keepNewLines());
	}
}