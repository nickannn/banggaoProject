package com.together.app;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/board")
public class BoardController {
	
	@Autowired
	BoardDao boardDao;
	
	@Autowired
	UserDao userDao;
	
	@RequestMapping("/list")
	public String boardList(Model m, HttpServletRequest req) {
		ArrayList<Board> boardList = boardDao.getBoardList();
		ArrayList<User> writerList = new ArrayList<>();
		ArrayList<Boolean> clickedLikeList = new ArrayList<>();
		
		HttpSession session = req.getSession();
		String email = (String)session.getAttribute("email");
		
		for(int i = 0; i < boardList.size(); i++) {
			User writer = userDao.selectUser(boardList.get(i).getWriterEmail());
			boolean clikedLike = boardDao.userLikeCheck(boardList.get(i).getId(), email);
			
			writerList.add(writer);
			clickedLikeList.add(clikedLike);
		}
		
		m.addAttribute("boardList", boardList);
		m.addAttribute("writerList", writerList);
		m.addAttribute("clickedLikeList", clickedLikeList);
		return "board";
	}
	
	@PostMapping("/add")
	public String boardAdd(String contents, HttpServletRequest req) {
		HttpSession session = req.getSession();
		String email = (String)session.getAttribute("email");
		Board board = new Board();
		int rowCnt = 0;
		
		board.setWriterEmail(email);
		board.setContents(contents);
	
		rowCnt = boardDao.insertBoard(board);
		
		if(rowCnt == 0) {
			String msg = "등록에 실패했습니다. 다시 시도해주세요.";
			req.setAttribute("msg", msg);
			return "alertAndBack";
		} else {
			String msg = "등록에 성공했습니다. :) 감사합니다.";
			String url = "/app/board/list";
			req.setAttribute("msg", msg);
			req.setAttribute("url", url);
			return "alertAndGo";
		}
	}
	
	@RequestMapping("/like")
	@ResponseBody
	public Map<String, Object> likeClick(String userEmail, int boardId, boolean likeStatus) {
		Map<String, Object> map = new HashMap<>();
		
		boolean userLikeCheck = boardDao.userLikeCheck(boardId, userEmail);
		int like_count = 0;
		
		if(userLikeCheck) {
			boardDao.likeCntDown(boardId, userEmail);
			like_count = boardDao.getLikeCount(boardId);
		}
		if(!userLikeCheck) {
			boardDao.likeCntUp(boardId, userEmail);
			like_count = boardDao.getLikeCount(boardId);
		}
		
		map.put("like_count", like_count);
		
		return map;
	}
}
