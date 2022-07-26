package com.together.app;

import java.util.Date;

public class User {
	private String userEmail;
	private String userPwd;
	private String userName;
	private Date userBirth;
	private String userGender;
	private String userNationality;
	private String userLanguage;
	private String userOrgImg;
	private String userSaveImg;
	private Date userReg_date;
	
	public User() {}
	
	public User(String userEmail, String userPwd, String userName, Date userBirth, String userGender,
			String userNationality, String userLanguage, String userOrgImg, String userSaveImg, Date userReg_date) {
		this.userEmail = userEmail;
		this.userPwd = userPwd;
		this.userName = userName;
		this.userBirth = userBirth;
		this.userGender = userGender;
		this.userNationality = userNationality;
		this.userLanguage = userLanguage;
		this.userOrgImg = userOrgImg;
		this.userSaveImg = userSaveImg;
		this.userReg_date = userReg_date;
	}
	
	public String getUserEmail() {
		return userEmail;
	}
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}
	public String getUserPwd() {
		return userPwd;
	}
	public void setUserPwd(String userPwd) {
		this.userPwd = userPwd;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public Date getUserBirth() {
		return userBirth;
	}
	public void setUserBirth(Date userBirth) {
		this.userBirth = userBirth;
	}
	public String getUserGender() {
		return userGender;
	}
	public void setUserGender(String userGender) {
		this.userGender = userGender;
	}
	public String getUserNationality() {
		return userNationality;
	}
	public void setUserNationality(String userNationality) {
		this.userNationality = userNationality;
	}
	public String getUserLanguage() {
		return userLanguage;
	}
	public void setUserLanguage(String userLanguage) {
		this.userLanguage = userLanguage;
	}
	public String getUserOrgImg() {
		return userOrgImg;
	}
	public void setUserOrgImg(String userOrgImg) {
		this.userOrgImg = userOrgImg;
	}
	public String getUserSaveImg() {
		return userSaveImg;
	}
	public void setUserSaveImg(String userSaveImg) {
		this.userSaveImg = userSaveImg;
	}
	public Date getUserReg_date() {
		return userReg_date;
	}
	public void setUserReg_date(Date userReg_date) {
		this.userReg_date = userReg_date;
	}
	
	@Override
	public String toString() {
		return "User [userEmail=" + userEmail + ", userPwd=" + userPwd + ", userName=" + userName + ", userBirth="
				+ userBirth + ", userGender=" + userGender + ", userNationality=" + userNationality + ", userLanguage="
				+ userLanguage + ", userOrgImg=" + userOrgImg + ", userSaveImg=" + userSaveImg + ", userReg_date="
				+ userReg_date + "]";
	}
}
