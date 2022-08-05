package com.together.app;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
public class HomeController {
	@Autowired
	UserDao userDao;
	
	@Autowired
	MeetingDao meetingDao;
	
	@GetMapping("/home")
	public String home() {
		return "index";
	}

	@PostMapping("/home") 
	public String login(String email, String pwd, boolean rememberMe, HttpServletRequest req, HttpServletResponse res, Model m){
		// 1. email 체크 
		if(!loginCheck(email, pwd)) {
			String msg = "email 혹은 password가 일치하지 않습니다.";
			req.setAttribute("msg", msg);
			return "alertAndBack";
		}
		
		// remember me 체크시 email 쿠키 설정
		if(rememberMe) {
			createCookie(email, res);
		} else {
			deleteCookie(email, res);
		}
		// 2. session에 user email 저장
		if(loginCheck(email, pwd)) {
			HttpSession session = req.getSession();
			session.setAttribute("email", email);
		}
		
		return "index";
	}

	@GetMapping("/logout")
	public String logout(HttpSession session, HttpServletRequest req, HttpServletResponse res) {	
		session.invalidate();
		String msg = "로그아웃되었습니다";
		String url = "/app/home";
		
		req.setAttribute("msg", msg);
		req.setAttribute("url", url);
		
		return "alertAndGo";
		//return "redirect:/home";
	}
	
	@RequestMapping("/about")
	public String aboutPage() {
		
		return "about";
	}
	
	private boolean loginCheck(String email, String pwd) {
		User user = userDao.selectUser(email);
		
		if(user == null)
			return false;
		
		return user.getUserPwd().equals(pwd);
	}
	
	private void createCookie(String email, HttpServletResponse res) {
		Cookie cookie = new Cookie("email", email);
		cookie.setMaxAge(60*60*24);
		res.addCookie(cookie);
	}
	
	private void deleteCookie(String email, HttpServletResponse res) {
		Cookie cookie = new Cookie("email", "");
		cookie.setMaxAge(0);
		res.addCookie(cookie);	
	}
}
