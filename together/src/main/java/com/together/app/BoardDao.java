package com.together.app;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class BoardDao {
	
	@Autowired
	DataSource ds;	
	
	public ArrayList<Board> getBoardList() {
		ArrayList<Board> list = new ArrayList<>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = "SELECT * FROM board";
		
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				Board board = new Board();
				int index = 1;
				
				board.setId(rs.getInt(index++));
				board.setWriterEmail(rs.getString(index++));
				board.setContents(rs.getString(index++));
				board.setLike_count(rs.getInt(index++));
				board.setFollowers(rs.getString(index++));
				board.setReg_date(new Date(rs.getTimestamp(index++).getTime()));
				
				list.add(board);
			}
		} catch(SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs, pstmt, conn);
		}
		return list;
	}
	
	public int insertBoard(Board board) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String sql = "INSERT INTO board(writerEmail, contents, reg_date)"
				+ " VALUES(?, ?, now())";
		
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			int index = 1;
			
			pstmt.setString(index++, board.getWriterEmail());
			pstmt.setString(index++, board.getContents().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			
			return pstmt.executeUpdate();
		} catch(SQLException e) {
			e.printStackTrace();
			return 0;
		} finally {
			close(pstmt, conn);
		}
	}
	
	public int deleteBoard(String id) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String sql = "DELETE FROM board WHERE id = ?";
		
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			
			return pstmt.executeUpdate();
		} catch(SQLException e) {
			e.printStackTrace();
			return 0;
		} finally {
			close(pstmt, conn);
		}
	}
	
	public int likeCntUp(int id, String email) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String followers = getFollowers(id);
		int like_count = getLikeCount(id);
		
		String sql = "UPDATE board SET like_count = ?, followers = ? WHERE id = ?";
		
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			int index = 1;
			
			followers = followers.trim();
			followers += " " + email;
			
			pstmt.setInt(index++, like_count + 1);
			pstmt.setString(index++, followers);
			pstmt.setInt(index++, id);
			
			return pstmt.executeUpdate();
		} catch(SQLException e) {
			e.printStackTrace();
			return 0;
		} finally {
			close(pstmt, conn);
		}
	}
	
	public int likeCntDown(int id, String email) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String followers = getFollowers(id);
		int like_count = getLikeCount(id);
		
		String sql = "UPDATE board SET like_count = ?, followers = ? WHERE id = ?";
		
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			int index = 1;
			
			followers = followers.replace(email, "").trim();
			
			pstmt.setInt(index++, like_count - 1);
			pstmt.setString(index++, followers);
			pstmt.setInt(index++, id);
			
			return pstmt.executeUpdate();
		} catch(SQLException e) {
			e.printStackTrace();
			return 0;
		} finally {
			close(pstmt, conn);
		}
	}
	
	public boolean userLikeCheck(int id, String email) {
		String followers = getFollowers(id);
		String[] splitedFollowers = null;
		
		if("".equals(followers)) {
			return false;
		} else {
			splitedFollowers = splitFollowers(followers);
				
			for(String follower : splitedFollowers) {
				if(follower.equals(email)) {
					return true;
				}
			}
		}
			
		return false;
	}
	
	public int getLikeCount(int id) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = "SELECT like_count FROM board WHERE id = ?";
		
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				int like_count = rs.getInt(1);
				return like_count;
			}
		} catch(SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs, pstmt, conn);
		}
		return 0;
	}
	
	private String getFollowers(int id) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String followers = null;
		
		String sql = "SELECT followers FROM board WHERE id = ?";
		
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				followers = rs.getString(1);
			}
		} catch(SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs, pstmt, conn);
		}
		return followers;
	}
	
	private String[] splitFollowers(String followers) {
		return followers.trim().split("\\s+");
	}
	
	private void close(AutoCloseable... autoCloseables) {
		for(AutoCloseable autoCloseable : autoCloseables) {
			try {
				if(autoCloseable != null)
					autoCloseable.close();
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
	}

	
}
