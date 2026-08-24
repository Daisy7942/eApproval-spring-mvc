package com.eapproval.common.util;

import org.jsoup.Jsoup;
import org.jsoup.safety.Safelist;

/**
 * 화면에서 올라온 값에서 위험한 태그를 털어낸다.
 *
 * 결재 본문은 Summernote 가 만든 HTML 이라 그대로 이스케이프하면 서식이 다 깨진다.
 * 그래서 "글자로 바꾸기"가 아니라 "허용 목록에 없는 태그를 지우기" 방식을 쓴다.
 * script 태그, onclick 같은 이벤트 속성, javascript: 로 시작하는 링크는
 * 허용 목록에 없으므로 전부 사라진다.
 *
 * 제목·사유·결재의견은 서식이 필요 없는 값이라 태그를 통째로 없앤다.
 */
public class HtmlSanitizer {

	// 본문에서 살려 둘 태그 목록
	private static final Safelist BODY = Safelist.relaxed()
			// Summernote 의 글자색·정렬은 style 속성에 담겨 온다.
			// 이걸 막으면 서식이 통째로 빠지므로 열어 둔다.
			// style 값 자체는 Jsoup 이 검사하지 않지만, 요즘 브라우저는
			// CSS 안의 javascript: 를 실행하지 않아 실행 경로가 없다.
			.addAttributes(":all", "style")
			// 에디터에서 붙여넣은 이미지는 data:image/... 형태로 들어온다.
			// relaxed 는 http/https 만 허용하므로 data 를 더해 준다.
			.addProtocols("img", "src", "data")
			.addTags("hr");

	private HtmlSanitizer() {
	}

	/** 결재 본문용. 서식은 남기고 위험한 것만 지운다. */
	public static String cleanBody(String html) {
		if (html == null) {
			return null;
		}
		return Jsoup.clean(html, BODY);
	}

	/** 제목·사유·의견용. 태그를 전부 지우고 글자만 남긴다. */
	public static String cleanText(String text) {
		if (text == null) {
			return null;
		}
		// clean 은 &lt; 같은 엔티티를 남기므로, 한 번 더 풀어서 사람이 읽는 글자로 되돌린다.
		return Jsoup.parse(Jsoup.clean(text, Safelist.none())).text();
	}
}
