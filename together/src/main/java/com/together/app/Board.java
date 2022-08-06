package com.together.app;

import java.util.Date;

public class Board {
	private int id;
	private String writerEmail;
	private String contents;
	private int like_count;
	private String followers;
	private Date reg_date;
	
	public Board() {}
	
	public Board(int id, String writerEmail, String contents, int like_count, String followers, Date reg_date) {
		super();
		this.id = id;
		this.writerEmail = writerEmail;
		this.contents = contents;
		this.like_count = like_count;
		this.followers = followers;
		this.reg_date = reg_date;
	}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getWriterEmail() {
		return writerEmail;
	}
	public void setWriterEmail(String writerEmail) {
		this.writerEmail = writerEmail;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public int getLike_count() {
		return like_count;
	}
	public void setLike_count(int like_count) {
		this.like_count = like_count;
	}
	public String getFollowers() {
		return followers;
	}
	public void setFollowers(String followers) {
		this.followers = followers;
	}
	public Date getReg_date() {
		return reg_date;
	}
	public void setReg_date(Date reg_date) {
		this.reg_date = reg_date;
	}

	@Override
	public String toString() {
		return "Board [id=" + id + ", writerEmail=" + writerEmail + ", contents=" + contents + ", like_count="
				+ like_count + ", followers=" + followers + ", reg_date=" + reg_date + "]";
	}
}
