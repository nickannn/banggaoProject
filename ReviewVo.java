package com.together.app;

import java.util.Date;

public class ReviewVo {

	private int revNum;
	private String revName;

	private String revContext;
	private Date regDate;
	
	public int getRevNum() {
		return revNum;
	}

	public void setRevNum(int revNum) {
		this.revNum = revNum;
	}

	public String getRevName() {
		return revName;
	}

	public void setRevName(String revName) {
		this.revName = revName;
	}


	public String getRevContext() {
		return revContext;
	}

	public void setRevContext(String revContext) {
		this.revContext = revContext;
	}

	public Date getRegDate() {
		return regDate;
	}

	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}

	@Override
	public String toString() {
		return "Review [revNum=" + revNum + ", revName=" + revName + ", revContext="
				+ revContext + ", regDate=" + regDate + "]";
	}




	public ReviewVo(int revNum, String revName, String revContext, Date regDate) {
		super();
		this.revNum = revNum;
		this.revName = revName;

		this.revContext = revContext;
		this.regDate = regDate;
	}
	
	public ReviewVo() {
		
	}

}
