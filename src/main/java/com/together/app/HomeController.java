package com.together.app;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.together.app.utils.JSFunction;


@Controller
public class HomeController {
	@Autowired
	UserDao userDao;
	
	@GetMapping(value = "/home")
	public String home() {	
		return "index";
	}
	
	@PostMapping(value="/home") 
	public String login(String email, String pwd, HttpServletRequest req, HttpServletResponse res){
		// 1. email 체크 
		if(!loginCheck(email, pwd)) {
			String msg = "email 혹은 password가 일치하지 않습니다.";
			JSFunction.alertAndBack(res, msg);
		}
		// 2. session에 user email 저장
		if(loginCheck(email, pwd)) {
			HttpSession session = req.getSession();
			session.setAttribute("email", email);
		}
		
		return "index";
	}
	
	@GetMapping(value="/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		
		return "redirect:/home";
	}
	
	private boolean loginCheck(String email, String pwd) {
		User user = userDao.selectUser(email);
		
		if(user == null)
			return false;
		
		return user.getUserPwd().equals(pwd);
	}
	
}
