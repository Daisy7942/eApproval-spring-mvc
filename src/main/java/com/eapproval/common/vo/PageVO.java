package com.eapproval.common.vo;

/**
 * 목록의 '어디를 어떻게 잘라 볼 것인가'를 한 덩어리로 들고 다니는 그릇.
 *
 * page · size · keyword · docType · status : 화면이 주는 값 (주소에 실려 온다)
 * total : DB 가 주는 값 (COUNT 쿼리 결과)
 * offset · lastPage : 위 값들로 계산해서 나오는 값이라 setter 가 없다
 *
 * 조건이 늘 때마다 Controller·Service·Mapper 의 인자를 하나씩 늘리는 대신
 * 이 그릇 하나만 주고받는다.
 */
public class PageVO {

	private int page = 1; // 지금 몇 페이지 (화면에서 온다)
	private int size = 10; // 한 쪽 몇 줄 (화면 드롭다운에서 온다)
	private int total; // 전체 건수 (DB 에서 세서 채운다)

	private String keyword; // 제목(·기안자) 검색어
	private String docType; // 결재양식 : FREE / VACATION
	private String status; // 결재상태 : PENDING / APPROVED / REJECTED

	// 자르지 않고 전부 가져오라는 표시. 대시보드처럼 상태별 개수를 세는 곳이 쓴다
	private boolean all;

	public PageVO() {
	}

	// 전부 가져올 때 : PageVO.all() 로 만든다
	public static PageVO all() {
		PageVO p = new PageVO();
		p.all = true;
		return p;
	}

	public boolean isAll() {
		return all;
	}

	public int getPage() {
		return page;
	}

	// ?page=0 이나 음수가 들어와도 1로 끌어올린다. 막는 자리를 여기 하나로 모은다
	public void setPage(int page) {
		this.page = (page < 1) ? 1 : page;
	}

	public int getSize() {
		return size;
	}

	// 드롭다운에 있는 값만 받는다. 주소창에 ?size=99999 를 쳐서
	// 전 건을 한 번에 긁어가는 것을 막는 자리이기도 하다
	public void setSize(int size) {
		this.size = (size == 10 || size == 20 || size == 50) ? size : 10;
	}

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}

	public String getKeyword() {
		return keyword;
	}

	// 화면에서 온 빈 문자열은 '조건 없음'으로 통일한다.
	// 그래야 XML 에서 null 하나만 보면 되고, 조건을 붙일지 말지가 한 군데서 갈린다
	public void setKeyword(String keyword) {
		this.keyword = blankToNull(keyword);
	}

	public String getDocType() {
		return docType;
	}

	public void setDocType(String docType) {
		this.docType = blankToNull(docType);
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = blankToNull(status);
	}

	private String blankToNull(String s) {
		return (s == null || s.trim().isEmpty()) ? null : s.trim();
	}

	// DB 는 페이지라는 개념을 모른다. '앞에서 몇 줄 건너뛸지'로 번역해 준다
	public int getOffset() {
		return (page - 1) * size;
	}

	// 45건 / 20줄 = 3장. 정수 나눗셈은 나머지를 버리니 size-1 을 더해 올림한다
	public int getLastPage() {
		if (total <= 0) {
			return 1;
		}
		return (total + size - 1) / size;
	}
}
