<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="java.net.URLDecoder" %>
<c:set var="loginOut" value="${empty sessionScope.email ? 'Login' : 'Logout'}" />
<c:set var="loginOutValue" value="${empty sessionScope.email ? '#' : '/app/logout'}" />
<c:set var="loginOutTarget" value="${empty sessionScope.email ? '#loginModal' : '/app/logout'}" />
<c:set var="loginOutModal" value="${empty sessionScope.email ? 'modal' : ''}" />
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css">
	<link rel="stylesheet" href="<c:url value='/resources/css/map.css'/>"/>
	<link rel="stylesheet" href="<c:url value='/resources/css/index.css'/>"/>
	<title>Meeting app</title>
</head>
<body>
	<header>
		<nav class="navbar navbar-light bg-light navbar-expand-lg" >
			<img class="logo-img" src="${path}/resources/img/logo.svg" alt="logo" />
			<h2 class="pt-3 font-weight-bold"><a href="/app/home" class="navbar-brand" style="font-size: 0.8em;">BANGGAO</a></h2>
			<button class="navbar-toggler" data-toggle="collapse"
				data-target="#navbarCollapse">
				<span class="navbar-toggler-icon"></span>	
			</button>
			<div class="collapse navbar-collapse" id="navbarCollapse">
				<ul class="navbar-nav ml-auto">
					<li class="navbar-item">
						<a href="/app/home" class="nav-link active">Home</a>
					</li>
					<li class="navbar-item">
						<a class="nav-link" data-toggle="${loginOutModal}" href="${loginOutTarget}">${loginOut}</a>
					</li>
					<c:if test="${empty sessionScope.email}">
						<li class="navbar-item">
							<a href="/app/signup/add" class="nav-link">SignUp</a>
						</li>
					</c:if>
					<li class="navbar-item">
						<a href="/app/about" class="nav-link">About</a>
					</li>
					<c:if test="${not empty sessionScope.email}">
						<li class="navbar-item">
							<a href="/app/board/list" class="nav-link">Board</a>
						</li>
					</c:if>
					<c:if test="${not empty sessionScope.email}">
						<li class="navbar-item">
							<a href="/app/mypage/profile" class="nav-link">MyPage</a>
						</li>
					</c:if>
				</ul>
			</div>
		</nav>
	</header>
	
	<main>
		<section class="banner mb-5">
			<div class="hero--img">
				<div class="hero--text">
					<h1 class="mb-3">Welcome to Banggao!</h1>
					<h5>Do you want to make some foreign friends? Don't hesitate to join us!</h5>
				</div>
			</div>
			<div class="bannerImg-container">
				<img src="../${path}/resources/img/banner_04.jpg" alt="banner_img" />
				<img src="../${path}/resources/img/banner_05.jpg" alt="banner_img" />
				<img src="../${path}/resources/img/banner_06.jpg" alt="banner_img" />	
				<img src="../${path}/resources/img/banner_03.jpg" alt="banner_img" />
				<img src="../${path}/resources/img/banner_01.jpg" alt="banner_img" />
				<img src="../${path}/resources/img/banner_02.jpg" alt="banner_img" />		
			</div>
		</section>
		<section class="content">
			<div class="meeting--btns mb-3">
				<button id="newMeetingBtn" class="btn btn-primary ml-2" data-toggle="modal">+ New</button>
				<button class="btn btn-secondary ml-2" onClick="window.location.reload();"><i class="bi bi-arrow-clockwise"></i></button>
			</div>
			<div class="meeting--tabs mb-3" id="nav-tab" role="tablist">
				<ul class="nav nav-tabs" id="region-tab">
					<li class="nav-item">
						<button type="button" class="nav-link active" id="nav-all-tab" data-toggle="tab" role="tab">All</button>
					</li>
					<li class="nav-item">
						<button type="button" class="nav-link" id="nav-seoul-tab" data-toggle="tab" role="tab">Seoul</button>
					</li>
					<li class="nav-item">
						<button type="button" class="nav-link" id="nav-busan-tab" data-toggle="tab" role="tab">Busan</button>
					</li>
					<li class="nav-item">
						<button type="button" class="nav-link" id="nav-daegu-tab" data-toggle="tab" role="tab">Daegu</button>
					</li>
				</ul>
			</div>
			
			<!-- 이 meeting-lists div 안에 meetingList ajax로 보여줄 것 -->
			<div id="meeting-lists" class="meetings-lists d-flex flex-wrap">
			</div>
		</section>
	</main>
	
	<footer>
		<h5>Copyright © 2022 채현진, 이창호 All Rights Reserved.</h5>
	</footer>
	
	<!-- Login modal -->
	<div class="modal fade" id="loginModal">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h3 class="modal-title">Log in</h3>
					<button type="button" class="close" data-dismiss="modal">
						<span>&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="<c:url value='/home' />" method="post" onsubmit="return loginFormCheck(this);">
						<div id="msg">
							<c:if test="${not empty param.msg}">
								<p> ${URLDecoder.decode(param.msg)}</p>
							</c:if>
						</div>
						<div class="form-group">
							<label for="email">Email</label>
							<input name="email" type="email" value="${cookie.email.value}" class="form-control" id="email" placeholder="Email" autofocus />
						</div>
						<div class="form-group">
							<label for="password">Password</label>
							<input name="pwd" type="password" class="form-control" id="password" placeholder="Password" />
						</div>
						<div class="form-group form-check">
							<input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe" ${empty cookie.email.value ? "" : "checked"} />
							<label class="form-check-label" for="rememberMe">Remember me</label>
						</div>
						<div class="row">
							<button class="btn btn-secondary col-sm-3 ml-auto" data-dismiss="modal">Cancel</button>
							<button class="btn btn-primary col-sm-3 offset-sm-4 mr-auto">Login</button>
						</div>							
					</form>
				</div>
				<div class="modal-footer">
					<a href="<c:url value='/signup/add'/>">Sign up</a>
				</div>	
			</div>
		</div>
	</div>
	
	<!-- meeting register modal -->
	<div class="modal fade" id="newMeetingModal" tabindex="-1" data-backdrop="static" data-keyboard="false">
		<div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
			<div class="modal-content">
				<div class="modal-header">
					<h3 class="modal-title">New Meeting</h3>
					<button type="button" class="close" data-dismiss="modal">
						<span>&times;</span>
					</button>
				</div>
				<div class="modal-body">	<!-- 제목, 소개, 날짜&시간, 위치맵, 사용언어, 모임인원 -->
					<form action="<c:url value='/meeting/add' />" method="post" enctype="multipart/form-data">
						<div class="form-group">
							<label for="title">Title</label>
							<input name="title" type="text" class="form-control" id="title" placeholder="Please enter the title..." autofocus required />
						</div>
						<div class="form-group">
							<label for="description">Brief description</label>
							<textarea name="description" class="form-control" id="description" placeholder="Write something briefly here..." style="resize:none;" rows="8" maxlength="300"></textarea>
						</div>
						<div class="form-group">
						<label for="mapBtn">Select the place</label><br>
							<button id="mapBtn" type="button" class="btn btn-dark mb-2" data-toggle="modal" data-target="#mapModal">+ Location</button>
							<div class="locationInfo">
								<input type="hidden" name="location_name" class="locationInfo--name--input" />
								<input type="hidden" name="location_address" class="locationInfo--address--input" />
								<h5 class="locationInfo--name"></h5>
								<h5 class="locationInfo--address"></h5>
							</div>
						</div>
						<div class="form-group">
							<label for="imageFile">Select the image(optional)</label>
							<input id="imageFile" type="file" name="imageFile" accept="image/*" onchange="setThumbnail(event);" />
							<div id="img_container"></div>
						</div>
						<div class="form-group">
							<label for="lang">Select the language</label>
							<select id="lang" name="language" class="custom-select" required>
							  	<option selected>--Select--</option>
							  	<option value="english">English</option>
							  	<option value="french">French</option>
							  	<option value="german">German</option>
							  	<option value="italian">Italian</option>
							  	<option value="japanese">Japanese</option>
							  	<option value="korean">Korean</option>
							  	<option value="portuguese">Portuguese</option>
							  	<option value="spanish">Spanish</option>
							</select>
						</div>
						<div class="form-group">
							<label>How many people can attend?</label><br>
							<div class="custom-control custom-radio custom-control-inline">
							  	<input type="radio" id="four" name="capacity" value="4" class="custom-control-input" checked />
							  	<label class="custom-control-label" for="four">4</label>
							</div>
							<div class="custom-control custom-radio custom-control-inline">
							  	<input type="radio" id="six" name="capacity" value="6" class="custom-control-input" />
							  	<label class="custom-control-label" for="six">6</label>
							</div>
							<div class="custom-control custom-radio custom-control-inline">
							  	<input type="radio" id="eight" name="capacity" value="8" class="custom-control-input" />
							  	<label class="custom-control-label" for="eight">8</label>
							</div>
						</div>
						<div class="form-group">
							<label for="dateTime">Select the date time</label>
							<input type="datetime-local" class="form-control" id="meetingDateTime" name="date" required />
						</div>
						<div class="form-group">
							<label for="kakaolink">Kakaotalk open chat link</label>
							<input type="text" class="form-control" id="kakaolink" name="kakaolink" placeholder="Write the link here..." />
						</div>
						<div class="modal-footer">
							<button class="btn btn-secondary mr-auto" data-dismiss="modal">Cancel</button>
							<button class="btn btn-primary">Submit</button>
						</div>							
					</form>
				</div>	
			</div>
		</div>
	</div>
	
	<!-- Kakao map Modal -->
	<div class="modal fade" id="mapModal" tabindex="-1" data-backdrop="static">
		<div class="modal-dialog modal-dialog-centered modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h3 class="modal-title">Choose the place for meeting</h3>
					<button type="button" class="close" data-dismiss="modal">
						<span>&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<div id="map_wrap">					
						<div id="map" style="width:100%;height:600px;position:relative;overflow:hidden;"></div>
					
						<div id="menu_wrap" class="bg_white">
					        <div class="option">
					            <div>
					                검색 : <input type="text" value="서면 맛집" id="keyword" size="15"> 
					                <button id="searchBtn" class="mt-1" type="button">Search</button> 
					               
					            </div>
					        </div>
					        <hr>
					        <ul id="placesList"></ul>
					        <div id="pagination"></div>
					   	</div>
					    
					</div>			
				</div>
				<div class="modal-body">
					<div class="placeinfo">
						<h4 class="placeinfo--title" style="font-weight:bold;"></h4>
						<h5 class="placeinfo--address"></h5>
					</div>
				</div>
				<div class="modal-footer">
					<button class="btn btn-secondary col-sm-3 mr-auto" data-dismiss="modal">Cancel</button>
					<button id="confirmBtn" class="btn btn-primary col-sm-3 ml-auto">Confirm</button>	
				</div>
			</div>
		</div>
	</div>
	
	<!-- modal for joining the meeting -->
	<div class="modal fade" id="joinModal">
		<div class="modal-dialog modal-dialog-centered modal-sm">
			<div class="modal-content">
				<div class="modal-header">
					<h3 class="modal-title">Join</h3>
					<button type="button" class="close" data-dismiss="modal">
						<span>&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<input type="hidden" id="joinModalId" disabled/>
					<p>Do you want to join this meeting?</p>
				</div>
				<div class="modal-footer">
					<button class="btn btn-secondary mr-auto" data-dismiss="modal">No</button>
					<button onclick="joinFunction()" class="btn btn-primary">Yes</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- modal for canceling the meeting -->
	<div class="modal fade" id="cancelModal">
		<div class="modal-dialog modal-dialog-centered modal-sm">
			<div class="modal-content">
				<div class="modal-header">
					<h3 class="modal-title">Cancel</h3>
					<button type="button" class="close" data-dismiss="modal">
						<span>&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<input type="hidden" id="cancelModalId" disabled/>
					<p>Are you sure you want to cancel this meeting?</p>
				</div>
				<div class="modal-footer">
					<button class="btn btn-secondary mr-auto" data-dismiss="modal">No</button>
					<button onclick="cancelFunction()" class="btn btn-danger">Yes</button>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript" src="<c:url value='../${path}/resources/js/dateTimeControl.js'/>"></script>
	
	<script src="https://code.jquery.com/jquery-3.2.1.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js" integrity="sha384-+sLIOodYLS7CIrQpBjl+C7nPvqq+FbNUBDunl/OZv93DB7Ln/533i8e/mZXLi/P+" crossorigin="anonymous"></script>
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.24.0/moment.min.js"></script>

	<!-- kakao map 관련 scripts -->
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=3edb9b3b1547ede1ea4d9bcbd14450aa&libraries=services"></script>	
	<script type="text/javascript" src="<c:url value='../${path}/resources/js/kakaomap.js'/>"></script>
	<script>
		var region;	// region category -> obviously, region is 'all' at first
		
		$(document).ready(function() {
			// 카드 일단 보여주고, expired date meeting이 있는 지 주기적으로 체크 (1분 간격으로)
			initialCardShow();
			setInterval(initialCardShow, 60000);
			
			// kakaomap 모달 창 지도 깨짐현상 방지 
			$("#mapModal").on('shown.bs.modal', function() {
				console.log("on");
				setTimeout(function() {
					console.log("works");
					map.relayout();
					map.setLevel(3);		// relayout 하고나면 맵이 전국 단위로 나오기에, 레벨 설정을 해준다.
				}, 10);
			});
			
			$("#newMeetingBtn").on('click', function() {	// new meeting modal 로그인 체크하고 보여주기 
				let email = "<c:out value='${sessionScope.email}' />";		// javascript로 session 값 사용하는 방법

				if(email === null || email.length < 1){
					alert("먼저 로그인을 해주세요. :)");
					$("#loginModal").modal('show');
				} else {
					$("#newMeetingModal").modal('show');
				}
			});
			
			$("#searchBtn").on('click', function() { 	// map 검색하기버튼누르면 함수 실행 
				console.log("clicked");
				searchPlaces();
			});
			
			$("#confirmBtn").on('click', function() {
				$("#mapModal").modal('hide');
				showConfirmedPlace();
			});
			
			$("#keyword").keypress(function(event) {
				if(event.key === "Enter") {
					document.getElementById("searchBtn").click();
				}
			});
			
			// 지역tab 에 따라 지역에 해당하는 meeting만 보여주기
			// ajax로 json 형식으로 meeting 데이터 끌어오기 
			$("button[data-toggle='tab']").on('shown.bs.tab', function(event) {
				console.log(event.target.id);
				
				if(event.target.id === "nav-all-tab") {
					region = "all";
				}
				if(event.target.id === "nav-seoul-tab") {
					region = "서울";
				}
				if(event.target.id === "nav-busan-tab") {
					region = "부산";
				}
				if(event.target.id === "nav-daegu-tab") {
					region = "대구";
				}
				
				let regionData = {'region':region}; 
				
				$.ajax({
					type: "POST",
					url: "${path}/meeting/get",
					data: regionData,
					dataType: "json",
					success: function(data) {
						getMeetingCard(data);
						
						$('[data-toggle="popover"]').popover();
					},
					error: function(data) {
						console.log("Error : " + data);
					}	
				});
			});
		});	
		// 처음에 홈화면 meeting card 보여주기
		
		function initialCardShow() {
			const regionData = {'region': region}; 
			
			$.ajax({
				type: "POST",
				url: "${path}/meeting/get",
				data: regionData,
				dataType: "json",
				success: function(data) {
					// 새로고침 안 해도 meeting 이미지 보이도록 하려면 setTimeout???
					setTimeout(function() {
						getMeetingCard(data);
						$('[data-toggle="popover"]').popover();
					}, 10);
				},
				error: function(jqXHR, textStatus, errorThrown) {
					console.log("Error occured");
					console.log(jqXHR);
					console.log(textStatus);
					console.log(errorThrown);
				}	
			});
		};
		
		// 메인기능인 card 가져오기 
		// 방 상태: 참가인원이 capacity보다 적으면 available, 같으면 full / 미팅시간이 현재시간 기준 2시간 이하면 expired  
		function getMeetingCard(data) {
			const email = "<c:out value='${sessionScope.email}' />";
			const currentTimestamp = Date.now();
			const limitHourGap = 7200000;	// 2시간 갭 
			let card = "";

			$.each(data, function(i) {
				const timeGap = data[i].date - currentTimestamp;	// 현재 시간과 미팅 시간사이의 갭
				 
				card += '<div class="card ml-3 mb-3" style="width: 20rem;">';
				card += '<img src=' + getImgSrc(data[i].attachedImage.imgUploadPath, data[i].attachedImage.uuid, data[i].attachedImage.fileName) + ' class="card-img-top" alt="room_img" />';
				card += '</img>';
				card += '<div class="card-body position-relative">';
				card += '<input type="hidden" value=' + data[i].id + ' disabled />';
				card += '<h5 class="card-title" style="max-width:90%;">#' + data[i].title + '</h5>';
				card += '<h6 class="card-subtitle text-muted mb-2">' + data[i].language + '</h6>';
				card += '<span class="card-text">';
				card += '<i class="bi bi-geo-alt-fill"></i>';
				card += " " + data[i].location_name + ", " + data[i].location_address;
				card += '</span>';
				card += '<button type="button" class="btn btn-info position-absolute" style="font-size:1.2em;top:20px;right:10px;" data-toggle="popover" title="About this meeting" data-content="' + data[i].description + '">+</button>';
				card += '</div>';
				card += '<ul class="list-group list-group-flush">';
				card += '<li class="list-group-item text-muted">';
				card += '<i class="bi bi-calendar-check-fill"></i>';
				card += '&nbsp;' + getDate(data[i].date) + '<br/>';
				card += '<i class="bi bi-clock-fill"></i>';
				card += '&nbsp;' + getTime(data[i].date);
				card += '</li>';
				card += '<li class="list-group-item">';
				card += '<i class="bi bi-people-fill"></i>';
				card += '&nbsp;' + getNop(data[i].participants) + " / " + data[i].capacity;
				
				if(timeGap < limitHourGap)
					card += '<span class="float-right" style="color:#6E6E6E;">expired</span>';
				else if(getNop(data[i].participants) === data[i].capacity)
					card += '<span class="float-right" style="color:#FE2E2E;">full</span>';
				else 
					card += '<span class="float-right" style="color:#31B404;">available</span>';
					
				card += '</li>';
				
				if((email !== null && email !== "") && data[i].participants !== null && data[i].participants.trim() !== "" && data[i].participants.trim().includes(email)) {
					card += '<li class="list-group-item">';
					card += '<a href="' + data[i].kakaolink + '" target="_blank">Kakaotalk Group Chat</a>';
					card += '</li>';
				}
				
				card += '</ul>';
				card += '<div class="card-body">';
				
				if(timeGap < limitHourGap)
					card += '<button type="button" class="btn btn-secondary btn-block" disabled>Closed</button>';	
				else if((email !== null && email !== "") && data[i].participants !== null && data[i].participants.trim() !== "" && data[i].participants.trim().includes(email))
					card += '<button type="button" onclick="cancelBtnHandle(' + data[i].id + ')" class="btn btn-danger btn-block">Cancel</button>';
				else 
					card += '<button type="button" onclick="joinBtnHandle(' + data[i].id + ')" class="joinBtn btn ' + (getNop(data[i].participants) === data[i].capacity ? "btn-secondary" : "btn-primary") + ' btn-block" ' + (getNop(data[i].participants) === data[i].capacity ? "disabled" : "") + '>Join</button>';
				
				card += '</div>';
				card += '</div>';
				
				$("#meeting-lists").empty();
				$("#meeting-lists").append(card);
			});
		}
		
		// card 이미지 경로
		function getImgSrc(imgPath, imgUuid, imgFileName) {
			return imgPath === null ? "../${path}/resources/img/default.jpg" : "../${path}/resources/upload_img/" + imgPath.replace("\\", "/") + "/t_" + imgUuid + "_" + imgFileName;
		}
		
		// date 형식 변환 
		function getDate(date) {
			return moment(date).format("YYYY-MM-DD");
		}
		
		// time 형식 변환
		function getTime(date) {
			return moment(date).format("HH:mm");;
		}
		
		// participants의 수
		function getNop(participants) {
			if(participants === null || participants === "") {
				return 0;
			} else {
				const str = participants.replace(/\s+/g, " ");	// 여러 공백 -> 단일 공백
				const splitPart = str.trim().split(" ");	// 단일 공백 기준 split

				return splitPart.length;
			}
		}
		
		// Join 버튼 누르면, 로그인 된 유저만 이용가능하도록 해야 함
		// Join Modal 안에 hidden input에 meeting room Id 넣어둬야 함. 구분을 해주기 위함. 
		function joinBtnHandle(meetingId) {
			let email = "<c:out value='${sessionScope.email}' />";
			
			if(email === null || email.length < 1){
				alert("먼저 로그인을 해주세요. :)");
				$("#loginModal").modal('show');
			} else {
				$("#joinModal").modal('show');
				$("#joinModalId").attr('value', meetingId);
			}
		}
		
		function joinFunction() {
			let email = "<c:out value='${sessionScope.email}' />";
			let meetingId = $("#joinModalId").val();
			let joinData = {'userEmail':email, 'meetingId':meetingId};
			
			$.ajax({
				type: "POST",
				url: "${path}/meeting/join",
				data: joinData,
				dataType: "json",
				success: function(data) {
					if(data === 1) {
						alert("모임에 등록했습니다. :)");
						
					} else if(data === 0) {
						alert("이미 해당 모임에 참여 중 입니다.");
					} else {
						alert("등록에 실패했습니다.");
					}
					$("#joinModal").modal('hide');
					window.location.reload(); 	// 임시 방편... 비동기 인원 변경 등 해결책 찾을 때 까지. 
				},
				error: function(data) {
					console.log("Error : " + data);
				}	
			});	
		}
		
		function cancelBtnHandle(meetingId) {
			let email = "<c:out value='${sessionScope.email}' />";
			
			if(email === null || email.length < 1){
				alert("먼저 로그인을 해주세요. :)");
				$("#loginModal").modal('show');
			} else {
				$("#cancelModal").modal('show');
				$("#cancelModalId").attr('value', meetingId);
			}
		}
		
		function cancelFunction() {
			let email = "<c:out value='${sessionScope.email}' />";
			let meetingId = $("#cancelModalId").val();
			let cancelData = {'userEmail':email, 'meetingId':meetingId};
			
			$.ajax({
				type: "POST",
				url: "${path}/meeting/cancel",
				data: cancelData,
				dataType: "json",
				success: function(data) {
					if(data === 1) {
						alert("모임에서 탈퇴하셨습니다. :)");
						
					} else {
						alert("탈퇴에 실패했습니다.");
					}
					$("#cancelModal").modal('hide');
					window.location.reload(); 	// 임시 방편... 비동기 인원 변경 등 해결책 찾을 때 까지. 
				},
				error: function(data) {
					console.log("Error : " + data);
				}	
			});	
		}
		 
	</script>
	<script>
		// new meeting modal 에서 input image 선택 시 thumbnail 보여주기 
		// jpg와 png 형식만 허용. 파일 크기 5MB로 제한.
		function setThumbnail(event) {
			if(document.querySelector("#imageFile").value === "") {
	   			document.querySelector("#img_container").innerHTML = "";
	   			return false;
	   		};
			// File check
			const checkResult = fileCheck(event);
			
			if(!checkResult) {
				return false;
			}
			
			// thumbnail 보여주깅 
			const reader = new FileReader();
			
			reader.onload = function(event) {
				document.querySelector("#img_container").innerHTML = "";
				
				const img = document.createElement("img");
				img.setAttribute("src", event.target.result);
				document.querySelector("#img_container").appendChild(img);
			};
			reader.readAsDataURL(event.target.files[0]);
		}
		
		function fileCheck(event) {
			const regex = new RegExp("(.*?)\.(jpg|png)$");
			const maxSize = 5242880; // 5MB
			
			if(event.target.files[0].size > maxSize) {
				alert("크기가 5MB 이하인 파일만 첨부 가능합니다.");
				event.target.value = "";
				document.querySelector("#img_container").innerHTML = "";
				return false;
			}
			
			if(!regex.test(event.target.files[0].name)) {
				alert("jpg와 png 이미지 파일만 첨부 가능합니다.");
				event.target.value = "";
				document.querySelector("#img_container").innerHTML = "";
				return false;
			}
			
			return true;
		}
		
		function loginFormCheck(form) {
			let msg ='';
			     
            if(form.email.value.length==0) {
               	document.getElementById("msg").innerHTML = 'email을 입력해주세요.'; 
                return false;
            }
    
            if(form.pwd.value.length==0) {
              	document.getElementById("msg").innerHTML = 'password를 입력해주세요.';
              	return false;
            }
            return true;
		}
	</script>
	
</body>
</html>