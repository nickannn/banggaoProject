<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap" rel="stylesheet" />
	<link rel="stylesheet" href="<c:url value='/resources/css/userProfile.css' />" />
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
						<a href="/app/home" class="nav-link">Home</a>
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
							<a href="/app/mypage/profile" class="nav-link active">MyPage</a>
						</li>
					</c:if>
				</ul>
			</div>
		</nav>
	</header>
	
	<main>
		<div class="profile--header">
			<c:choose>
				<c:when test="${not empty user.getAttachedImage().getFileName()}">
					<img class="profile--header--img" src="${path}/resources/upload_userProfileImg/${fn:replace(user.getAttachedImage().getImgUploadPath(), '\\', '/')}/t_${user.getAttachedImage().getUuid()}_${user.getAttachedImage().getFileName()}" alt="profile_img" />
				</c:when>
				<c:otherwise>
					<img class="profile--header--img" src="${path}/resources/img/${user.getUserGender() eq 'male' ? 'default_profile_male.svg' : 'default_profile_female.svg'}" alt="profile_img" />
				</c:otherwise>
			</c:choose>
			<h2 class="ml-3">${user.getUserName()}&nbsp;</h2>
			<c:choose>
				<c:when test="${user.getUserGender() eq 'male'}">
					<i class="bi bi-gender-male" style="color: blue; font-size:1.3em;"></i>
				</c:when>
				<c:otherwise>
					<i class="bi bi-gender-female" style="color: red; font-size:1.3em;"></i>
				</c:otherwise>
			</c:choose>
			<button type="button" class="btn btn-lg btn-outline-primary rounded-pill px-5 py-2 ml-auto">Edit</button>
		</div>
		<div class="profile--body">
			<div class="d-flex align-items-center mb-4">
				<i class="bi bi-person-circle" style="font-size: 2rem;"></i>
				<h3 class="ml-4 pt-2" style="letter-spacing:.2rem;">User Info</h3>
			</div>
			<div class="userInfo--container">
				<div class="userInfo--email">
					<h5 class="userInfo--label">Email</h5>
					<h5 class="userInfo--info">${user.getUserName()}</h5>		
				</div>
			</div>
			<div class="userInfo--container">
				<div class="userInfo--dob">
					<h5 class="userInfo--label">Date of Birth</h5>
					<h5 class="userInfo--info">
						<fmt:formatDate value="${user.getUserBirth()}" pattern="yyyy-MM-dd"></fmt:formatDate>
					</h5>
				</div>
			</div>
			<div class="userInfo--container">
				<div class="userInfo--nationality">
					<h5 class="userInfo--label">Nationality</h5>
					<h5 class="userInfo--info">${user.getUserNationality()}</h5>
				</div>
			</div>	
			<div class="userInfo--container">
				<div class="userInfo--language">
					<h5 class="userInfo--label">Language</h5>
					<h5 class="userInfo--info">${user.getUserLanguage()}</h5>
				</div>
			</div>
		</div>
	</main>
	
	<footer>
		<h5>Copyright © 2022 채현진, 이창호 All Rights Reserved.</h5>
	</footer>

<script src="https://code.jquery.com/jquery-3.2.1.js" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js" integrity="sha384-+sLIOodYLS7CIrQpBjl+C7nPvqq+FbNUBDunl/OZv93DB7Ln/533i8e/mZXLi/P+" crossorigin="anonymous"></script>
</body>
</html>