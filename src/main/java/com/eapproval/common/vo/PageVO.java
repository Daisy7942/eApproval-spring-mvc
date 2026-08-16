package com.eapproval.common.vo;

/**
 * 목록 페이징 정보를 한 덩어리
 *
 * page  · size  : 화면이 주는 값 (주소의 ?page=2, 20/50/100 드롭다운)
 * total         : DB 가 주는 값 (COUNT 쿼리 결과)
 * offset · lastPage : 위 셋으로 계산해서 나오는 값이라 setter 가 없다
 */
public class PageVO {

	private int page = 1; // 지금 몇 페이지 (화면에서 온다)
	private int size = 20; // 한 쪽 몇 줄 (드롭다운 살리면 화면에서 온다)
	private int total; // 전체 건수 (DB 에서 세서 채운다)

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

	public void setSize(int size) {
		this.size = (size < 1) ? 20 : size;
	}

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
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
