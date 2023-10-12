package com.together.app;


import java.util.ArrayList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


@Controller  //POJO
public class ReviewController {
		
	@Autowired
	ReviewDao reviewDao;
	
	@RequestMapping(value = "reviewHome")
	public String index(Model m) {
		ArrayList<ReviewVo> list = reviewDao.getReviewList();
		
		m.addAttribute("reviewList",list);
		return "review";
	}
	
	@RequestMapping(value = "reviewAdd", method = RequestMethod.POST)
	public String reviewAdd(@ModelAttribute ReviewVo reviewVo, Model m) {
		
		reviewDao.insertReview(reviewVo);
		
		
		return "redirect:/reviewHome";
	}


}

