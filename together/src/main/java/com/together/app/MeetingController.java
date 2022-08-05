package com.together.app;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import net.coobird.thumbnailator.Thumbnails;

@Controller
@RequestMapping("/meeting")
public class MeetingController {
	
	@Autowired
	MeetingDao meetingDao;
	
	@InitBinder
	public void toDate(WebDataBinder binder) {
	   SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
	   binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, false));
	}
	
	@PostMapping("/add") 
	public String meetingAdd(String title, String description, String location_name, String location_address,
			MultipartFile imageFile, String language, Date date, int capacity, String kakaolink, HttpServletRequest req) {
		AttachedImage attachedImage = new AttachedImage();
		
		if(imageFile.getOriginalFilename() != null && !"".equals(imageFile.getOriginalFilename())) {
			attachedImage = imageFileUpload(imageFile);
		}
			
		HttpSession session = req.getSession();
		String userEmail = (String) session.getAttribute("email");
		
		int rowCnt = 0;
		
		if(userEmail != null) {
			Meeting meeting = new Meeting();
			String region = location_address.trim().split(" ")[0];
		
			meeting.setTitle(title);
			meeting.setDescription(description);
			meeting.setRegion(region);
			meeting.setLocation_name(location_name);
			meeting.setLocation_address(location_address);
			meeting.setLanguage(language);
			meeting.setDate(date);
			meeting.setCapacity(capacity);
			meeting.setKakaolink(kakaolink);
			meeting.setAttachedImage(attachedImage);
			meeting.setHostEmail(userEmail);
		
			rowCnt = meetingDao.insertMeeting(meeting);
		}
		
		if(rowCnt == 0) {
			String msg = "meeting 등록에 실패했습니다. 다시 시도해주세요.";
			req.setAttribute("msg", msg);
			return "alertAndBack";
		} else {
			String msg = "meeting 등록에 성공했습니다. :) 감사합니다.";
			String url = "/app/home";
			req.setAttribute("msg", msg);
			req.setAttribute("url", url);
			return "alertAndGo";
		}
	}

	@PostMapping("/get")
	@ResponseBody
	public ArrayList<Meeting> getMeetings(@RequestParam(required=false, defaultValue="all") String region) {
		ArrayList<Meeting> meetingList = null;
		
		meetingList = meetingDao.getMeetingList(region);

		return meetingList;
	}

	@PostMapping("/join")
	@ResponseBody
	public int meetingJoin(String userEmail, String meetingId, Model m) {
		String participants = null;
		participants = meetingDao.checkParticipants(userEmail, meetingId);

		if("already".equals(participants)) {
			return 0;	// 이미 참여 중인 유저
		} else if("fail".equals(participants)) {
			return -1;	// 오류
		} else {
			// 1: 성공, 0: 이미 참여 중인 그룹, -1: 그 외의 실패
			return meetingDao.updateMeetingParticipants(participants, userEmail, meetingId);
		}
	}
	
	@PostMapping("/cancel")
	@ResponseBody
	public int meetingCancel(String userEmail, String meetingId) {
		return meetingDao.cancelMeeting(userEmail, meetingId);
	}
	// 이미지 파일 업로드 함수
	private AttachedImage imageFileUpload(MultipartFile imageFile) {
		// 이미지파일 관리가 용이하도록 날짜 기준으로 이미지 업로드 폴더에 하위 폴더들을 만들어준다. 
		String imageUploadFolder = "C:\\sts3_project\\together\\src\\main\\webapp\\resources\\upload_img";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date todayDate = new Date();
		
		String today = sdf.format(todayDate);
		String datePath = today.replace("-", File.separator);
				
		File imageUploadPath = new File(imageUploadFolder, datePath);	// imageUploadFolder의 하위에 년, 월, 일 별 폴더를 생성하기 위함 
		if(imageUploadPath.exists() == false) {		// 해당 폴더가 있는지 체크하고 없으면 만들어야 함
			imageUploadPath.mkdirs();
		}
				
		try {
			AttachedImage attachedImage = new AttachedImage();		// Upload할 Image의 정보를 담을 DTO
			String imageFileName = imageFile.getOriginalFilename();		// Original File Name
			String uuid = UUID.randomUUID().toString();		// 파일명 중복방지를 위한 고유식별자
			
			attachedImage.setFileName(imageFileName);	// DTO 인스턴스에 정보 저장
			attachedImage.setImgUploadPath(datePath);
			attachedImage.setUuid(uuid);
			
			imageFileName = uuid + "_" + imageFileName;		// uuid 적용시킨 File Name
			
			
			File saveFile = new File(imageUploadPath, imageFileName);	// File object that contains File path and filename
			imageFile.transferTo(saveFile);		// image file save
			
			// thumbnail 생성하기 
			File thumbnailImage = new File(imageUploadPath, "t_" + imageFileName);
			BufferedImage bufferedImage = ImageIO.read(saveFile);
			
			// ratio, width, height 설정
			double ratio = 3;
			int width = (int) (bufferedImage.getWidth() / ratio);
			int height = (int) (bufferedImage.getHeight() / ratio);
			
			Thumbnails.of(saveFile)
			.size(width, height)
			.toFile(thumbnailImage);	// thumbnail image file save
			
			return attachedImage;
		} catch (IllegalStateException e) {
			e.printStackTrace();
			return null;
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		} 	
	}
}
