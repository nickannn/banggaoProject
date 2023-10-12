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
public class MeetingDao {
	
	@Autowired
	DataSource ds;	
	
	public int insertMeeting(Meeting meeting) {		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String sql = "INSERT INTO meeting(title, description, region, location_name, location_address, "
				+ "language, date, capacity, hostEmail, kakaolink, "
				+ "imgUploadPath, uuid, fileName, reg_date) "
				+ "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now())";
		
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			int index = 1;
			// XXS 공격을 방지하기 위한 replaceAll...
			pstmt.setString(index++, meeting.getTitle().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(index++, meeting.getDescription().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(index++, meeting.getRegion());
			pstmt.setString(index++, meeting.getLocation_name().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(index++, meeting.getLocation_address().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(index++, meeting.getLanguage());
			pstmt.setTimestamp(index++, new java.sql.Timestamp(meeting.getDate().getTime()));
			pstmt.setInt(index++, meeting.getCapacity());
			pstmt.setString(index++, meeting.getHostEmail());
			pstmt.setString(index++, meeting.getKakaolink());
			pstmt.setString(index++, meeting.getAttachedImage().getImgUploadPath());
			pstmt.setString(index++, meeting.getAttachedImage().getUuid());
			pstmt.setString(index++, meeting.getAttachedImage().getFileName());
			
			return pstmt.executeUpdate();
		} catch(SQLException e) {
			e.printStackTrace();
			return 0;
		} finally {
			close(pstmt, conn);
		} 
	}
	// delete meeting 구현은 되어 있지만, 아직 사용하지는 말 것. (meeting 참석자가 있는 데 방장이라는 이유로 자유자재로 없애는 건 좀...) 
	public int deleteMeeting(String meetingId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String sql = "DELETE FROM meeting WHERE id = ?";
		
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(meetingId));
			
			return pstmt.executeUpdate();
		} catch(SQLException e) {
			e.printStackTrace();
			return 0;
		} finally {
			close(pstmt, conn);
		}	
	}
	// 조건문에 sql where 절 다르게 넣어서 ajax로 어떻게 연동?
	public ArrayList<Meeting> getMeetingList(String region) {
		ArrayList<Meeting> list = new ArrayList<>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		
		if("all".equals(region)) {
			sql = "SELECT * FROM meeting ORDER BY date";
		} else {
			sql = "SELECT * FROM meeting WHERE region = ? ORDER BY date";
		}
		
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			
			if(!"all".equals(region))	
				pstmt.setString(1, region);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				Meeting meeting = new Meeting();
				AttachedImage attachedImage = new AttachedImage();
				int index = 1;
				
				meeting.setId(rs.getInt(index++));
				meeting.setTitle(rs.getString(index++));
				meeting.setDescription(rs.getString(index++));
				meeting.setRegion(rs.getString(index++));
				meeting.setLocation_name(rs.getString(index++));
				meeting.setLocation_address(rs.getString(index++));
				meeting.setLanguage(rs.getString(index++));
				meeting.setDate(new Date(rs.getTimestamp(index++).getTime()));
				meeting.setCapacity(rs.getInt(index++));
				meeting.setHostEmail(rs.getString(index++));
				meeting.setParticipants(rs.getString(index++));
				meeting.setKakaolink(rs.getString(index++));
				attachedImage.setImgUploadPath(rs.getString(index++));
				attachedImage.setUuid(rs.getString(index++));
				attachedImage.setFileName(rs.getString(index++));
				meeting.setAttachedImage(attachedImage);
				meeting.setReg_date(new Date(rs.getTimestamp(index++).getTime()));
				
				list.add(meeting);
			}
		} catch(SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs, pstmt, conn);
		}
		
		return list;
	}
	// 이메일 체크 해서 이미 그 meeting 등록한 멤버인지 확인, 혹시 participants의 수와 capacity가 같은 지 체크 
	public String checkParticipants(String userEmail, String meetingId) {
		String[] partArr = null;
		String participants = null;
		int capacity = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = "SELECT participants, capacity FROM meeting WHERE id = ?";
		
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(meetingId));
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				participants = rs.getString(1);
				capacity = rs.getInt(2);
			}
			
			if(participants == null || "".equals(participants)) {
				participants = "";		
			} else {			// 해당 meeting에 participant가 한 명 이상 있다면
				partArr = splitParticipants(participants);
				
				for(String part : partArr) {
					if(part.equals(userEmail))		
						return "already";			// return already -> 해당 유저가 이미 참여 중인 그룹임.
				}
				
				if(partArr.length == capacity) {
					return "fail";		// return fail -> 혹시나, 이미 participant 수가 최대 허용 인원 수일 경우
				}
			}
		} catch(SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs, pstmt, conn);
		}
		
		return participants;
	}
	
	// userEmail을 participants에 등록
	public int updateMeetingParticipants(String participants, String userEmail, String meetingId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String sql = "UPDATE meeting SET participants = ? WHERE id = ?";
		
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			
			participants = participants.trim();
			participants += " " + userEmail;
			
			pstmt.setString(1, participants);
			pstmt.setInt(2, Integer.parseInt(meetingId));
			
			return pstmt.executeUpdate();
		} catch(SQLException e) {
			e.printStackTrace();
			return -1;
		} finally {
			close(pstmt, conn);
		}
	}
	
	// meeting 참가 취소
	public int cancelMeeting(String userEmail, String meetingId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String participants = getParticipants(userEmail, meetingId);
		
		if(participants != null) {
			participants = participants.replace(userEmail, "").trim();
		}
		
		String sql = "UPDATE meeting SET participants = ? WHERE id = ?";
		
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, participants);
			pstmt.setInt(2, Integer.parseInt(meetingId));
			
			return pstmt.executeUpdate();
		} catch(SQLException e) {
			e.printStackTrace();
			return -1;
		} finally {
			close(pstmt, conn);
		}
	}
	
	private String getParticipants(String userEmail, String meetingId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String participants = null;
		
		String sql = "SELECT participants FROM meeting WHERE id = ?";
		
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, meetingId);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				participants = rs.getString(1);
			}
		} catch(SQLException e) {
			e.printStackTrace();
		} finally {
			close(rs, pstmt, conn);
		}
		return participants;
	}
	
	private String[] splitParticipants(String participants) {
		return participants.trim().split("\\s+");
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
