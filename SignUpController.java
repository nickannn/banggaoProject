package com.together.app;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import net.coobird.thumbnailator.Thumbnails;

@Controller
@RequestMapping(value="/signup")
public class SignUpController {
	
	@Autowired
	UserDao userDao;
	
	@InitBinder
	public void toDate(WebDataBinder binder) {
	   SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	   binder.registerCustomEditor(Date.class, new CustomDateEditor(df, false));
	}
	
	@GetMapping(value="/add")
	public String signup() {
		return "signUpForm";
	}
	
	@PostMapping(value="/save") 
	public String save(String userEmail, String userPwd, String userName, String userGender, 
			Date userBirth, String userNationality, String userLanguage, MultipartFile imageFile,
			HttpServletRequest req, HttpServletResponse res) {
		System.out.println("fileName = " + imageFile.getOriginalFilename());
		AttachedImage attachedImage = new AttachedImage();
		
		if(imageFile.getOriginalFilename() != null && !"".equals(imageFile.getOriginalFilename())) {
			attachedImage = imageFileUpload(imageFile);
		}
		
		int rowCnt = 0;
		if(!signupCheck(userEmail)) {
			String msg = "이미 사용중인 email입니다. 다시 시도해주세요.";
			req.setAttribute("msg", msg);
			return "alertAndBack";
		} else {
			User user = new User();
			user.setUserEmail(userEmail);
			user.setUserPwd(userPwd);
			user.setUserName(userName);
			user.setUserBirth(userBirth);
			user.setUserGender(userGender);
			user.setUserNationality(userNationality);
			user.setUserLanguage(userLanguage);
			user.setAttachedImage(attachedImage);
			
			rowCnt = userDao.insertUser(user);
		}
		 
		if(rowCnt == 0) {
			String msg = "회원가입에 실패했습니다. 다시 시도해주세요.";
			req.setAttribute("msg", msg);
			return "alertAndBack";
		} else {
			String msg = "회원가입에 성공했습니다. 환영합니다~!";
			String url = "/app/home";
			req.setAttribute("msg", msg);
			req.setAttribute("url", url);
			return "alertAndGo";
		}
	}
	
	private boolean signupCheck(String userEmail) {
		User dbUser = userDao.selectUser(userEmail);
		System.out.println(dbUser);
		return dbUser == null ? true : false;
	}
	
	private AttachedImage imageFileUpload(MultipartFile imageFile) {
		// 이미지파일 관리가 용이하도록 날짜 기준으로 이미지 업로드 폴더에 하위 폴더들을 만들어준다. 
		String imageUploadFolder = "C:\\sts3_project\\together\\src\\main\\webapp\\resources\\upload_userProfileImg";
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
