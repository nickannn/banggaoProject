<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="loginOut" value="${sessionScope.email == null ? 'Login' : 'Logout'}" />
<c:set var="loginOutValue" value="${sessionScope.email == null ? '#' : '/app/logout'}" />
<c:set var="loginOutTarget" value="${sessionScope.email == null ? '#loginModal' : '/app/logout'}" />
<c:set var="loginOutModal" value="${sessionScope.email == null ? 'modal' : ''}" />
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap" rel="stylesheet" />
	<link rel="stylesheet" href="<c:url value='/resources/css/signup.css' />" />
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
							<a href="/app/signup/add" class="nav-link active">SignUp</a>
						</li>
					</c:if>
					<li class="navbar-item">
						<a href="/app/about" class="nav-link">About</a>
					</li>
				</ul>
			</div>
		</nav>
	</header>
	
	<main>
    	<form class="signup--container" method="post" action="<c:url value='/signup/save'/>" onsubmit="return formCheck(this);" enctype="multipart/form-data">
    		<h2>Welcome!</h2>
    		
    		<input type="email" name="userEmail" placeholder="Email" maxlength="30" required />
    		<input type="password" name="userPwd" placeholder="Password" pattern="[a-zA-Z0-9]{6,}" maxlength="20" required />
            <input type="password" name="pwd_check" placeholder="Confirm Password" pattern="[a-zA-Z0-9]{6,}" maxlength="20" required />
        	<input type="text" name="userName" placeholder="Name" maxlength="20" required />
        	
        	<div class="signup--gender">
    		 	<input id="male" type="radio" name="userGender" value="male" checked />
    		 	<label for="male">Male</label> 
          		<input id="female" type="radio" name="userGender" value="female" />
        		<label for="female">Female</label>
        	</div>
        	<div class="signup--birth">
        		<label for="birth">Date of Birth: &nbsp;</label>
        		<input type="date" id="birth" name="userBirth" value="2010-01-01" min="1960-01-01" max="2010-12-31" />
        	</div>
        	<div class="signup--nationality">
	        	<label for="nationality">Where are you from? &nbsp;</label>
	        	<select name="userNationality" id="nationality" required>
	        		<option value="">--Select--</option>
	        		<option value="brazil">Brazil</option>
	        		<option value="denmark">Denmark</option>
	        		<option value="england">England</option>
	        		<option value="france">France</option>
	        		<option value="germany">Germany</option>
	        		<option value="italy">Italy</option>
	        		<option value="japan">Japan</option>
	        		<option value="korea">Korea</option>
	        		<option value="spain">Spain</option>
	        		<option value="usa">USA</option>
	        	</select>
        	</div>
        	<div class="signup--language">
	        	<label for="languages">Choose your languages: &nbsp;</label>
	        	<select name="userLanguage" id="languages" size="4" multiple required>
	        		<option value="english" selected>English</option>
	        		<option value="french">French</option>
	        		<option value="german">German</option>
	        		<option value="italian">Italian</option>
	        		<option value="japanese">Japanese</option>
	        		<option value="korean">Korean</option>
	        		<option value="portuguese">Portuguese</option>
	        		<option value="spanish">Spanish</option>
	        	</select>
        	</div>
        	<div class="signup--image">
        		<label for="imageFile">Select the image(optional): </label>
				<input id="imageFile" type="file" name="imageFile" accept="image/*" onchange="setThumbnail(event);" />
				<div id="img_container"></div>
        	</div>
        	<button type="submit">Sign up</button>
    	</form>
    	
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
						<form action="<c:url value='/home' />" method="post">
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
								<input type="checkbox" class="form-check-input" id="rememberMe" ${empty cookie.email.value ? "" : "checked"} />
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
    </main>
    
    <footer>
		<h5>Copyright © 2022 채현진, 이창호 All Rights Reserved.</h5>
	</footer>
    
   	<script>
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
			const maxSize = 1048576; // 1MB
			
			if(event.target.files[0].size > maxSize) {
				alert("크기가 1MB 이하인 파일만 첨부 가능합니다.");
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
   	
   		function formCheck(form) {   			
   			if(form.userEmail.value.length < 8) {
   				alert("email은 최소 8자 이상으로 입력하세요.");
   				return false;
   			}
   			if(form.userPwd.value !== form.pwd_check.value) {
   				alert("password를 다시 확인해주세요.");
   				return false;
   			}
   			return true;
   		}
   	</script>
   	<script src="https://code.jquery.com/jquery-3.2.1.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js" integrity="sha384-+sLIOodYLS7CIrQpBjl+C7nPvqq+FbNUBDunl/OZv93DB7Ln/533i8e/mZXLi/P+" crossorigin="anonymous"></script>
</body>
</html>