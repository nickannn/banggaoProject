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
				AttachedImage attachedImage = new AttachedImage();
				int index = 1;
				
				user.setUserEmail(rs.getString(index++));
				user.setUserPwd(rs.getString(index++));
				user.setUserName(rs.getString(index++));
				user.setUserBirth(new Date(rs.getDate(index++).getTime()));
				user.setUserGender(rs.getString(index++));
				user.setUserNationality(rs.getString(index++));
				user.setUserLanguage(rs.getString(index++));
				attachedImage.setImgUploadPath(rs.getString(index++));
				attachedImage.setUuid(rs.getString(index++));
				attachedImage.setFileName(rs.getString(index++));
				user.setAttachedImage(attachedImage);
				user.setUserReg_date(new Date(rs.getTimestamp(index++).getTime()));
			}
		} catch(SQLException e) {
			e.printStackTrace();
			return null;
		} finally {
			close(rs, pstmt, conn);
		}
		return user;
	}
	
	public int insertUser(User user) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String sql = "INSERT INTO user VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now())";
		
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			int index = 1;
			
			pstmt.setString(index++, user.getUserEmail());
			pstmt.setString(index++, user.getUserPwd());
			pstmt.setString(index++, user.getUserName());
			pstmt.setDate(index++, new java.sql.Date(user.getUserBirth().getTime()));
			pstmt.setString(index++, user.getUserGender());
			pstmt.setString(index++, user.getUserNationality());
			pstmt.setString(index++, user.getUserLanguage());
			pstmt.setString(index++, user.getAttachedImage().getImgUploadPath());
			pstmt.setString(index++, user.getAttachedImage().getUuid());
			pstmt.setString(index++, user.getAttachedImage().getFileName());
			
			return pstmt.executeUpdate();
		} catch(SQLException e) {
			e.printStackTrace();
			return 0;
		} finally {
			close(pstmt, conn);
		}
	}
	
	public int deleteUser(String email) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String sql = "DELETE FROM user WHERE userEmail = ?";
		
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, email);
			
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
