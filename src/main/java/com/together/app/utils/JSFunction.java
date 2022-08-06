package com.together.app.utils;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletResponse;

public class JSFunction {
	public static void init(HttpServletResponse response) {
		response.setContentType("text/html; charset=utf-8");
	}
	
	public static void alert(HttpServletResponse response, String msg) {
		init(response);
		PrintWriter out = null;
		try {
			out = response.getWriter();
		} catch (IOException e) {
			e.printStackTrace();
		}
		out.println("<script>alert('" + msg + "');</script>");
		out.flush();	
	}
	
	public static void alertAndBack(HttpServletResponse response, String msg) {
		init(response);
		PrintWriter out = null;
		try {
			out = response.getWriter();
		} catch (IOException e) {
			e.printStackTrace();
		}
		out.println("<script>alert('" + msg + "'); history.back();</script>");
		out.flush();
	}
	
	public static void alertAndMove(HttpServletResponse response, String msg, String location) {
		init(response);
		PrintWriter out = null;
		try {
			out = response.getWriter();
		} catch (IOException e) {
			e.printStackTrace();
		}
		out.println("<script>alert('" + msg + "'); location.href='" + location + "';</script>");
		out.flush();
	}
}
