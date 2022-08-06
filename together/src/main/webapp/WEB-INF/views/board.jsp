<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="loginOut"
	value="${sessionScope.email == null ? 'Login' : 'Logout'}" />
<c:set var="loginOutValue"
	value="${sessionScope.email == null ? '#' : '/app/logout'}" />
<c:set var="loginOutTarget"
	value="${sessionScope.email == null ? '#loginModal' : '/app/logout'}" />
<c:set var="loginOutModal"
	value="${sessionScope.email == null ? 'modal' : ''}" />
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no" />

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"
	integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N"
	crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css">
<link rel="stylesheet" href="<c:url value='/resources/css/board.css' />" />
<title>Meeting app</title>
</head>
<body>
	<!-- header nav -->
	<header style="opacity: 0.9;">
		<nav class="navbar navbar-light bg-light navbar-expand-lg">
			<img class="logo-img" src="${path}/resources/img/logo.svg" alt="logo" />
			<h2 class="pt-3 font-weight-bold"><a href="/app/home" class="navbar-brand" style="font-size: 0.8em;">BANGGAO</a></h2>
			<button class="navbar-toggler" data-toggle="collapse"
				data-target="#navbarCollapse">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarCollapse">
				<ul class="navbar-nav ml-auto">
					<li class="navbar-item"><a href="/app/home" class="nav-link">Home</a>
					</li>
					<li class="navbar-item"><a class="nav-link"
						data-toggle="${loginOutModal}" href="${loginOutTarget}">${loginOut}</a>
					</li>
					<c:if test="${empty sessionScope.email}">
						<li class="navbar-item"><a href="/app/signup/add"
							class="nav-link">SignUp</a></li>
					</c:if>
					<li class="navbar-item">
						<a href="/app/about" class="nav-link">About</a>
					</li>
					<c:if test="${not empty sessionScope.email}">
						<li class="navbar-item">
							<a href="/app/board/list" class="nav-link active">Board</a>
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
		<div class="mt-5 mb-3">
			<button id="newCommentBtn" class="btn btn-primary ml-2" data-toggle="modal" data-target="#newCommentModal">+ New</button>
			<button class="btn btn-secondary ml-2" onClick="window.location.reload();"><i class="bi bi-arrow-clockwise"></i></button>
		</div>
		
		<c:if test="${not empty boardList}">
			<div id="comments-list" class="comments-list d-flex flex-wrap">
				<c:forEach var="i" begin="0" end="${boardList.size() - 1}">
					<div class="comment--container">
						<div class="comment--header d-flex mb-3">
							<c:choose>
								<c:when test="${not empty writerList.get(i).attachedImage.fileName}">
									<img class="comment--profileThumb" src="${path}/resources/upload_userProfileImg/${fn:replace(writerList.get(i).attachedImage.imgUploadPath, '\\', '/')}/t_${writerList.get(i).attachedImage.uuid}_${writerList.get(i).attachedImage.fileName}" alt="profile_img" />
								</c:when>
								<c:otherwise>
									<img class="comment--profileThumb" src="${path}/resources/img/${writerList.get(i).getUserGender() eq 'male' ? 'default_profile_male.svg' : 'default_profile_female.svg'}" alt="profile_img" />
								</c:otherwise>
							</c:choose>
							<div class="comment--profileName">
								<h3 style="font-size:1.5em"><c:out value="${writerList.get(i).userName}" /></h3>
								<h4 style="font-size:1.1em;color:grey;"><c:out value="${writerList.get(i).userEmail}" /></h4>
							</div>
						</div>
						<div class="comment--body">
							<p class="mb-3" style="font-size:1.15em;"><c:out value="${boardList.get(i).contents}" /></p>
							
						</div>
						<div class="comment--footer">
							<span style="color:grey;"><fmt:formatDate value="${boardList.get(i).reg_date}" pattern="yyyy-MM-dd  /  HH : mm"></fmt:formatDate></span>
							<hr/>
							<c:choose>
								<c:when test="${clickedLikeList.get(i)}">
									<button type="button" class="likeBtn" onclick="likeBtnClick(event)"><i id="${boardList.get(i).id}" class="bi bi-heart-fill" style="font-size:1.1em; color:red;"></i></button>
								</c:when>
								<c:otherwise>
									<button type="button" class="likeBtn" onclick="likeBtnClick(event)"><i id="${boardList.get(i).id}" class="bi bi-heart" style="font-size:1.1em; color:red;"></i></button>
								</c:otherwise>
							</c:choose>
							<span id="likeCnt${boardList.get(i).id}"><c:out value="${boardList.get(i).like_count}" /></span>
						</div>
					</div>
				</c:forEach>
			</div>
		</c:if>
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
					<form action="<c:url value='/home' />" method="post"
						onsubmit="return loginFormCheck(this);">
						<div id="msg">
							<c:if test="${not empty param.msg}">
								<p>${URLDecoder.decode(param.msg)}</p>
							</c:if>
						</div>
						<div class="form-group">
							<label for="email">Email</label> <input name="email" type="email"
								value="${cookie.email.value}" class="form-control" id="email"
								placeholder="Email" autofocus />
						</div>
						<div class="form-group">
							<label for="password">Password</label> <input name="pwd"
								type="password" class="form-control" id="password"
								placeholder="Password" />
						</div>
						<div class="form-group form-check">
							<input type="checkbox" class="form-check-input" id="rememberMe"
								name="rememberMe" ${empty cookie.email.value ? "" : "checked"} />
							<label class="form-check-label" for="rememberMe">Remember me</label>
						</div>
						<div class="row">
							<button class="btn btn-secondary col-sm-3 ml-auto"
								data-dismiss="modal">Cancel</button>
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
	
	<!-- new comment modal -->
	<div class="modal fade" id="newCommentModal" tabindex="-1" data-backdrop="static" data-keyboard="false">
		<div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
			<div class="modal-content">
				<div class="modal-header">
					<h3 class="modal-title">Write Something</h3>
					<button type="button" class="close" data-dismiss="modal">
						<span>&times;</span>
					</button>
				</div>
				<div class="modal-body">	
					<form action="<c:url value='/board/add' />" method="post">
						<div class="form-group">
							<label for="contents">Comment</label>
							<textarea name="contents" class="form-control" id="contents" placeholder="Write something here..." style="resize:none;" rows="8" maxlength="300" minlength="10"></textarea>
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
	


	<script src="https://code.jquery.com/jquery-3.2.1.js"
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"
		integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN"
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js"
		integrity="sha384-+sLIOodYLS7CIrQpBjl+C7nPvqq+FbNUBDunl/OZv93DB7Ln/533i8e/mZXLi/P+"
		crossorigin="anonymous"></script>
		
	<script>
		$(document).ready(function() {
			$('[data-toggle="popover"]').popover();
			
		});	
		
		function likeBtnClick(event) {
			
			let email = "<c:out value='${sessionScope.email}' />";
			let boardId = event.target.id;
			let likeStatus = event.target.classList[1] === 'bi-heart-fill' ? true : false;
			let likeData = {'userEmail':email, 'boardId':boardId, 'likeStatus':likeStatus};
			
			$.ajax({
				type: "POST",
				url: "${path}/board/like",
				data: likeData,
				dataType: "json",
				success: function(data) {
					let likeIcon = document.getElementById(boardId);
					
					if(likeIcon.classList.contains('bi-heart-fill')) {
						likeIcon.classList.remove('bi-heart-fill');
						likeIcon.classList.add('bi-heart');
					} else {
						likeIcon.classList.remove('bi-heart');
						likeIcon.classList.add('bi-heart-fill');
					}
					document.getElementById('likeCnt' + boardId).innerHTML = "";
					document.getElementById('likeCnt' + boardId).innerHTML = data.like_count;
				},
				error: function(data) {
					console.log("Error : " + data);
				}	
			});	
			
			
		}
	</script>	
</body>
</html>