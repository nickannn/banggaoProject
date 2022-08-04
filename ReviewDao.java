package com.together.app;


import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;



@Repository
public class  ReviewDao {

	@Autowired
	DataSource ds;
	
	
	public ReviewVo selectList(int revNum) {
		ReviewVo reviewVo = new ReviewVo();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = "SELCET * FROM review";
		
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, revNum);
			
			rs = pstmt.executeQuery();
			while(rs.next()) {
				int index = 1;
				reviewVo.setRevNum(rs.getInt(index++));
				reviewVo.setRevName(rs.getString(index++));
				reviewVo.setRevContext(rs.getString(index++));
				reviewVo.setRegDate(new Date(rs.getTimestamp(index++).getTime()));
				
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		} finally{
			try {
				rs.close();
				pstmt.close();
				conn.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return reviewVo;
		}
	
	
	public int insertReview(ReviewVo reviewVo) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String sql = "INSERT INTO review (revName, revContext, regDate) values (?,?,now())";
		
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			int index = 1;
			
			pstmt.setString(index++, reviewVo.getRevName());
			pstmt.setString(index++, reviewVo.getRevContext());
						
			return pstmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return 0 ;
		} finally{
			try {
				
				pstmt.close();
				conn.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		}
	
	
	public ArrayList<ReviewVo> getReviewList(){
		
		ArrayList<ReviewVo> list = new ArrayList<>();
		
		Connection conn = null;// ds.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = "SELECT * FROM review";
		
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				ReviewVo reviewVo = new ReviewVo();
				
			
				reviewVo.setRevName(rs.getString("revName"));
				reviewVo.setRevContext(rs.getString("revContext"));
				reviewVo.setRegDate(new Date(rs.getTimestamp("regDate").getTime()));
				list.add(reviewVo);
			}
		}catch(SQLException e ) {
			e.printStackTrace();
		}finally {
			try {
				rs.close();
				pstmt.close();
				conn.close();
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
		return list;
		
	}

}

