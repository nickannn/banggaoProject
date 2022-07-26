package com.together.app;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.together.app.utils.JSFunction;

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
			Date userBirth, String userNationality, String userLanguage, HttpServletResponse res) {
		
		System.out.println(userBirth);
		
		int rowCnt = 0;
		if(!signupCheck(userEmail)) {
			String msg = "이미 사용중인 email입니다. 다시 시도해주세요.";
			JSFunction.alertAndBack(res, msg);
		} else {
			User user = new User();
			user.setUserEmail(userEmail);
			user.setUserPwd(userPwd);
			user.setUserName(userName);
			user.setUserBirth(userBirth);
			user.setUserGender(userGender);
			user.setUserNationality(userNationality);
			user.setUserLanguage(userLanguage);
			
			rowCnt = userDao.insertUser(user);
		}
		 
		if(rowCnt == 0) {
			String msg = "회원가입에 실패했습니다. 다시 시도해주세요.";
			JSFunction.alertAndBack(res, msg);
		} else {
			String msg = "회원가입에 성공했습니다. 환영합니다~!";
			String location = "/app/home";
			JSFunction.alertAndMove(res, msg, location);
		}
		
		return "redirect:/home";
	}
	
	private boolean signupCheck(String userEmail) {
		User dbUser = userDao.selectUser(userEmail);
		System.out.println(dbUser);
		return dbUser == null ? true : false;
	}
}
