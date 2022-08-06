<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap"
	rel="stylesheet" />
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"
	integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N"
	crossorigin="anonymous">
<link rel="stylesheet"
	href="<c:url value='/resources/css/about.css'/>" />
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
						<a href="/app/about" class="nav-link active">About</a>
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

	<section class="hero">
		<div class="container">
			<div class="about-info">
				<h1 class="title">Banggao?</h1>
				<p class="infomation">
					Banggao는 한국어인 '반가워'를 영어로 표현한 단어입니다.<br>
				</p>
				<br>

				<h1 class="title">Who?</h1>
				<h2 class="subtitle">어떤사람들이 쓸까요?</h2>
				<ul>
					<li>한국을 좀 더 알고싶어 오래동안 체류하거나, 한국문화에 관심이 많은 외국인이나</li>
					<li>외국문화에 관심이 있고, 외국친구를 사귀고싶은 한국인들을 대상으로 만든 웹 사이트입니다.</li>
				</ul>
				<p class="infomation"></p>
				<h1 class="title">why?</h1>
				<h2 class="subtitle">왜 이것을 만들었나요?</h2>
				<ul>
					<li>meeff같은 데이팅앱이나, Tandem같은 채팅앱이 주류있지만 한국에서 잘 활성화 되지는 않았고,
						meet-up 같이 외국인들과 같이 어울릴 수 있는 웹 앱을 만들어보고자 하였습니다.</li>
					<li>장기적으로 한국에 체류하는 외국인들도 한국친구를 만나 한국이라는 나라를 좀 더 깊게 알고,<br>
						언어와 문화를 교류하며 좋은 추억을 쌓을 수 있게 도와주고 싶었습니다.
					</li>
					<li>한국인에게는 각국의 다양한 친구들과 소통하면서 더 넓은 세계를 배울 수 있게끔 발판이 되어주고
						싶었습니다.</li>
				</ul>
				<p class="infomation"></p>

			</div>
		</div>
	</section>
	<section class="member-section">
		<h2 class="corp">🍒CHAE-LEE Corp.</h2>
		<div class="container">
			<ul>
				<li><img src="${path}/resources/img/person.jpg" alt="">
					<h3>Hyunjin Chae(CTO)</h3>
					<p>java, react, 이것저것만들고 이것저것
						구현해봤습니다.asdfasfewqfawefasdfaewfqwaefafafaefea</p></li>
				<li><img src="${path}/resources/img/person.jpg" alt="">
					<h3>Changho LEE</h3>
					<p>java, react, 이것저것만들고 이것저것 구현해봤습니다.afefaefafawefasefaefafaw</p></li>
			</ul>
		</div>
	</section>
	
	<section class="contact-section">
		<div class="container">
			<div class="contact-left">
				<h2>Contact</h2>

				<form action="">
					<label for="name">Name</label> <input type="text" id="name"
						name="name"> <label for="message">Messgae</label>
					<textarea name="message" id="message" cols="30" rows="10"></textarea>

					<input type="submit" class="send-message-cta" value="Send Message">
				</form>
			</div>
			<h1>LOCATION</h1>
			<div id="map" style="width: 500px; height: 400px;"></div>
			<script type="text/javascript"
				src="//dapi.kakao.com/v2/maps/sdk.js?appkey=3edb9b3b1547ede1ea4d9bcbd14450aa&libraries=services"></script>
			<script>
				var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
				mapOption = {
					center : new kakao.maps.LatLng(35.1371847, 129.0988611), // 지도의 중심좌표
					level : 3
				// 지도의 확대 레벨
				};
				var markerPosition = new kakao.maps.LatLng(35.1371847,
						129.0988611);
				// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
				var map = new kakao.maps.Map(mapContainer, mapOption);

				var marker = new kakao.maps.Marker({
					position : markerPosition
				});

				// 마커가 지도 위에 표시되도록 설정합니다
				marker.setMap(map);
			</script>
		</div>
		<p>주소 : 부산광역시 남구 부전동 194-7</p>
	</section>
	<section class="finish-section">
		<img src="${path}/resources/img/friends.jpg" alt="마무리">
		<div class="container-finish">저희 🍒CHAE-LEE는 항상 더 많은 한국인들과 외국인들의
			소통을 위해 노력하겠습니다.</div>
		<div class="container-thanksTo">
			<h3 style="font-size: 1.2em;">Special Thanks To:</h3>
			<h4 style="font-size: 1.1em;">Abbey Lee</h4>
			<h4 style="font-size: 1.1em;">Becca Lee</h4>
			<h4 style="font-size: 1.1em;">Alex</h4>
		</div>
	</section>
	






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
</body>
</html>