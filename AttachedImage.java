package com.together.app;

public class AttachedImage {
	private String imgUploadPath;
	private String uuid;
	private String fileName;
	
	public String getImgUploadPath() {
		return imgUploadPath;
	}
	public void setImgUploadPath(String imgUploadPath) {
		this.imgUploadPath = imgUploadPath;
	}
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
	@Override
	public String toString() {
		return "AttachedImage [imgUploadPath=" + imgUploadPath + ", uuid=" + uuid + ", fileName=" + fileName + "]";
	}
}
