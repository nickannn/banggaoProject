package com.together.app;

import java.util.Date;

public class Meeting {
	private int id;
	private String title;
	private String description;
	private String region;
	private String location_name;
	private String location_address;
	private String language;
	private Date date;
	private int capacity;
	private String hostEmail;
	private String participants;
	private String kakaolink;
	private AttachedImage attachedImage;
	private Date reg_date;

	public Meeting() {}
	
	public Meeting(int id, String title, String description, String region, String location_name, String location_address,
			String language, Date date, int capacity, String hostEmail, String participants, String kakaolink, AttachedImage attachedImage, Date reg_date) {
		super();
		this.id = id;
		this.title = title;
		this.description = description;
		this.region = region;
		this.location_name = location_name;
		this.location_address = location_address;
		this.language = language;
		this.date = date;
		this.capacity = capacity;
		this.hostEmail = hostEmail;
		this.participants = participants;
		this.kakaolink = kakaolink;
		this.attachedImage = attachedImage;
		this.reg_date = reg_date;
	}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getRegion() {
		return region;
	}
	public void setRegion(String region) {
		this.region = region;
	}
	public String getLocation_name() {
		return location_name;
	}
	public void setLocation_name(String location_name) {
		this.location_name = location_name;
	}
	public String getLocation_address() {
		return location_address;
	}
	public void setLocation_address(String location_address) {
		this.location_address = location_address;
	}
	public String getLanguage() {
		return language;
	}
	public void setLanguage(String language) {
		this.language = language;
	}
	public Date getDate() {
		return date;
	}
	public void setDate(Date date) {
		this.date = date;
	}
	public int getCapacity() {
		return capacity;
	}
	public void setCapacity(int capacity) {
		this.capacity = capacity;
	}
	public String getHostEmail() {
		return hostEmail;
	}
	public void setHostEmail(String hostEmail) {
		this.hostEmail = hostEmail;
	}
	public String getParticipants() {
		return participants;
	}
	public void setParticipants(String participants) {
		this.participants = participants;
	}
	public String getKakaolink() {
		return kakaolink;
	}
	public void setKakaolink(String kakaolink) {
		this.kakaolink = kakaolink;
	}
	public AttachedImage getAttachedImage() {
		return attachedImage;
	}
	public void setAttachedImage(AttachedImage attachedImage) {
		this.attachedImage = attachedImage;
	}
	public Date getReg_date() {
		return reg_date;
	}
	public void setReg_date(Date reg_date) {
		this.reg_date = reg_date;
	}

	@Override
	public String toString() {
		return "Meeting [id=" + id + ", title=" + title + ", description=" + description + ", region=" + region
				+ ", location_name=" + location_name + ", location_address=" + location_address + ", language="
				+ language + ", date=" + date + ", capacity=" + capacity + ", hostEmail=" + hostEmail
				+ ", participants=" + participants + ", kakaolink=" + kakaolink + ", attachedImage=" + attachedImage
				+ ", reg_date=" + reg_date + "]";
	}
}
