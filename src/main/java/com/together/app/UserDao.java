package com.together.app;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class UserDao {

	@Autowired
	DataSource ds;	
	
	public User selectUser(String email) {
		User user = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = "SELECT * FROM user WHERE userEmail = ?";
		
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, email);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				user = new User();
				user.setUserEmail(rs.getString(1));
				user.setUserPwd(rs.getString(2));
				user.setUserName(rs.getString(3));
				user.setUserBirth(new Date(rs.getDate(4).getTime()));
				user.setUserGender(rs.getString(5));
				user.setUserNationality(rs.getString(6));
				user.setUserLanguage(rs.getString(7));
				user.setUserOrgImg(rs.getString(8));
				user.setUserSaveImg(rs.getString(9));
				user.setUserReg_date(new Date(rs.getTimestamp(10).getTime()));
			}
		} catch(SQLException e) {
			e.printStackTrace();
			return null;
		} finally {
			close(rs, pstmt, conn);
		}
		System.out.println(user);
		
		return user;
	}
	
	public int insertUser(User user) {
		int rowCnt = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String sql = "INSERT INTO user VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, now())";
		
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user.getUserEmail());
			pstmt.setString(2, user.getUserPwd());
			pstmt.setString(3, user.getUserName());
			pstmt.setDate(4, new java.sql.Date(user.getUserBirth().getTime()));
			pstmt.setString(5, user.getUserGender());
			pstmt.setString(6, user.getUserNationality());
			pstmt.setString(7, user.getUserLanguage());
			pstmt.setString(8, user.getUserOrgImg());
			pstmt.setString(9, user.getUserSaveImg());
			
			return pstmt.executeUpdate();
		} catch(SQLException e) {
			e.printStackTrace();
			return 0;
		} finally {
			close(pstmt, conn);
		}
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
