package com.together.app;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/mypage")
public class ProfileController {
	
	@Autowired
	UserDao userDao;
	
	@RequestMapping("/profile")
	public String showProfile(HttpServletRequest req, Model m) {
		HttpSession session = req.getSession();
		String email = (String) session.getAttribute("email");
		
		User user = userDao.selectUser(email);
		
		m.addAttribute("user", user);
		
		return "userProfile";
	}
}
