<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.net.URLDecoder" %>
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
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous" />
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&display=swap" rel="stylesheet" />
<link rel="stylesheet" href="<c:url value='../${path}/resources/css/map.css'/>"/>
<style>
	* {
	    box-sizing: border-box;
	    padding: 0;
	    margin: 0;
	    font-family: 'Inter', sans-serif;
	}
	
	html {
	    height: 100%;
	}
	
	main {
		margin-top: 65px;
	}
	
	.logo-img {
		width: 40px; 
		margin-right: 10px;
	}
	
	.modal-content {
		border-radius: 10px;
	}
	
	.banner {
		height: 400px;
	}
</style>
<title>Meeting app</title>
</head>
<body>
	<header>
		<nav class="navbar navbar-light bg-light navbar-expand-lg fixed-top" >
			<img class="logo-img" src="resources/img/logo.svg" alt="logo" />
			<h2><a href="#" class="navbar-brand">Together</a></h2>
			<button class="navbar-toggler" data-toggle="collapse"
				data-target="#navbarCollapse">
				<span class="navbar-toggler-icon"></span>	
			</button>
			<div class="collapse navbar-collapse" id="navbarCollapse">
				<ul class="navbar-nav ml-auto">
					<li class="navbar-item">
						<a href="#" class="nav-link active">Home</a>
					</li>
					<li class="navbar-item">
						<a class="nav-link" data-toggle="${loginOutModal}" href="${loginOutTarget}">${loginOut}</a>
					</li>
					<li class="navbar-item">
						<a href="#" class="nav-link">About</a>
					</li>
					<li class="navbar-item">
						<a href="#" class="nav-link">Contact</a>
					</li>
				</ul>
			</div>
		</nav>
	</header>
	
	<main>
		<section class="banner">
			<h1>banner section</h1>			
		</section>
		<section class="content">
			<h2>Meetings</h2>
			<div class="meeting--btns">
				<button class="btn btn-primary ml-2 mb-3" data-toggle="modal" data-target="#newMeetingModal">+ New</button>
			</div>
			<div class="meeting--tabs mb-3" id="nav-tab" role="tablist">
				<ul class="nav nav-tabs" id="region-tab">
					<li class="nav-item">
						<a href="#" class="nav-link active" id="nav-all-tab" data-toggle="tab" role="tab">All</a>
					</li>
					<li class="nav-item">
						<a href="#" class="nav-link" id="nav-seoul-tab" data-toggle="tab" role="tab">Seoul</a>
					</li>
					<li class="nav-item">
						<a href="#" class="nav-link" id="nav-busan-tab" data-toggle="tab" role="tab">Busan</a>
					</li>
					<li class="nav-item">
						<a href="#" class="nav-link" id="nav-daegu-tab" data-toggle="tab" role="tab">Daegu</a>
					</li>
				</ul>
			</div>
			<div class="meetings-lists">
			</div>
		</section>
	</main>
	
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
							<input name="email" type="email" class="form-control" id="email" placeholder="Email" autofocus />
						</div>
						<div class="form-group">
							<label for="password">Password</label>
							<input name="pwd" type="password" class="form-control" id="password" placeholder="Password" />
						</div>
						<div class="form-group form-check">
							<input type="checkbox" class="form-check-input" id="remember" />
							<label class="form-check-label" for="remember">Remember me</label>
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
	<div class="modal fade" id="newMeetingModal" data-backdrop="static" data-keyboard="false">
		<div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
			<div class="modal-content">
				<div class="modal-header">
					<h3 class="modal-title">New Meeting</h3>
					<button type="button" class="close" data-dismiss="modal">
						<span>&times;</span>
					</button>
				</div>
				<div class="modal-body">	<!-- 제목, 소개, 날짜&시간, 위치맵, 사용언어, 모임인원 -->
					<form action="<c:url value='' />" method="post" onsubmit="return meetingFormCheck(this);">
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
							<div class="locationName">
								<h5></h5>
							</div>
						</div>
						<div class="form-group">
							<label for="lang">Select the language</label>
							<select id="lang" class="custom-select">
							  	<option selected>--Select--</option>
							  	<option value="en">English</option>
							  	<option value="fr">French</option>
							  	<option value="ge">German</option>
							  	<option value="it">Italian</option>
							  	<option value="ja">Japanese</option>
							  	<option value="ko">Korean</option>
							  	<option value="po">Portuguese</option>
							  	<option value="sp">Spanish</option>
							</select>
						</div>
						<div class="form-group">
							<label>How many people can attend?</label><br>
							<div class="custom-control custom-radio custom-control-inline">
							  	<input type="radio" id="four" name="capacity" class="custom-control-input" checked />
							  	<label class="custom-control-label" for="four">4</label>
							</div>
							<div class="custom-control custom-radio custom-control-inline">
							  	<input type="radio" id="six" name="capacity" class="custom-control-input" />
							  	<label class="custom-control-label" for="six">6</label>
							</div>
							<div class="custom-control custom-radio custom-control-inline">
							  	<input type="radio" id="eight" name="capacity" class="custom-control-input" />
							  	<label class="custom-control-label" for="eight">8</label>
							</div>
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
	<div class="modal fade" id="mapModal" data-backdrop="static">
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
					                키워드 : <input type="text" value="서면 맛집" id="keyword" size="15"> 
					                <button id="searchBtn" type="button">검색하기</button> 
					               
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
	<footer></footer>
	
	<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
	
	<!-- kakao map 관련 scripts -->
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=3edb9b3b1547ede1ea4d9bcbd14450aa&libraries=services"></script>	
	<script>
			var placeName;
			var placeAddress;
			
			var markers = [];
			
			var container = document.getElementById('map');
			var options = {
				center: new kakao.maps.LatLng(35.1555459,129.0612181),
				level: 3
			};
									
			var map = new kakao.maps.Map(container, options);
			
			var zoomControl = new kakao.maps.ZoomControl();
			map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT); 
			
			// 장소 검색 객체를 생성합니다
			var ps = new kakao.maps.services.Places();  

			// 검색 결과 목록이나 마커를 클릭했을 때 장소명을 표출할 인포윈도우를 생성합니다
			var infowindow = new kakao.maps.InfoWindow({zIndex:1});

			// 키워드로 장소를 검색합니다
			searchPlaces();
			
			// 키워드 검색을 요청하는 함수입니다
			function searchPlaces() {

			    var keyword = document.getElementById('keyword').value;

			    if (!keyword.replace(/^\s+|\s+$/g, '')) {
			        alert('키워드를 입력해주세요!');
			        return false;
			    }

			    // 장소검색 객체를 통해 키워드로 장소검색을 요청합니다
			    ps.keywordSearch(keyword, placesSearchCB); 
			}

			// 장소검색이 완료됐을 때 호출되는 콜백함수 입니다
			function placesSearchCB(data, status, pagination) {
			    if (status === kakao.maps.services.Status.OK) {

			        // 정상적으로 검색이 완료됐으면
			        // 검색 목록과 마커를 표출합니다
			        displayPlaces(data);

			        // 페이지 번호를 표출합니다
			        displayPagination(pagination);

			    } else if (status === kakao.maps.services.Status.ZERO_RESULT) {

			        alert('검색 결과가 존재하지 않습니다.');
			        return;

			    } else if (status === kakao.maps.services.Status.ERROR) {

			        alert('검색 결과 중 오류가 발생했습니다.');
			        return;

			    }
			}

			// 검색 결과 목록과 마커를 표출하는 함수입니다
			function displayPlaces(places) {

			    var listEl = document.getElementById('placesList'), 
			    menuEl = document.getElementById('menu_wrap'),
			    fragment = document.createDocumentFragment(), 
			    bounds = new kakao.maps.LatLngBounds(), 
			    listStr = '';
			    
			    // 검색 결과 목록에 추가된 항목들을 제거합니다
			    removeAllChildNods(listEl);

			    // 지도에 표시되고 있는 마커를 제거합니다
			    removeMarker();
			    
			    for ( var i=0; i<places.length; i++ ) {

			        // 마커를 생성하고 지도에 표시합니다
			        var placePosition = new kakao.maps.LatLng(places[i].y, places[i].x),
			            marker = addMarker(placePosition, i), 
			            itemEl = getListItem(i, places[i]); // 검색 결과 항목 Element를 생성합니다

			        // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
			        // LatLngBounds 객체에 좌표를 추가합니다
			        bounds.extend(placePosition);

			        // 마커와 검색결과 항목에 mouseover 했을때
			        // 해당 장소에 인포윈도우에 장소명을 표시합니다
			        // mouseout 했을 때는 인포윈도우를 닫습니다
			        (function(marker, title, address) {
			            kakao.maps.event.addListener(marker, 'mouseover', function() {
			                displayInfowindow(marker, title);
			            });

			            kakao.maps.event.addListener(marker, 'mouseout', function() {
			                infowindow.close();
			            });

			            itemEl.onmouseover =  function () {
			                displayInfowindow(marker, title);
			            };

			            itemEl.onmouseout =  function () {
			                infowindow.close();
			            };
			            
			            // 클릭 이벤트 추가
			            kakao.maps.event.addListener(marker, 'click', function() {		   
			            	console.log(title);
			            	console.log(address);
			            	showSelectedPlaceInfo(title, address);
			            });
			            
			        })(marker, places[i].place_name, places[i].road_address_name);

			        fragment.appendChild(itemEl);
			    }

			    // 검색결과 항목들을 검색결과 목록 Element에 추가합니다
			    listEl.appendChild(fragment);
			    menuEl.scrollTop = 0;

			    // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
			    map.setBounds(bounds);
			}

			// 검색결과 항목을 Element로 반환하는 함수입니다
			function getListItem(index, places) {

			    var el = document.createElement('li'),
			    itemStr = '<span class="markerbg marker_' + (index+1) + '"></span>' +
			                '<div class="info">' +
			                '   <h5>' + places.place_name + '</h5>';

			    if (places.road_address_name) {
			        itemStr += '    <span>' + places.road_address_name + '</span>' +
			                    '   <span class="jibun gray">' +  places.address_name  + '</span>';
			    } else {
			        itemStr += '    <span>' +  places.address_name  + '</span>'; 
			    }
			                 
			      itemStr += '  <span class="tel">' + places.phone  + '</span>' +
			                '</div>';           

			    el.innerHTML = itemStr;
			    el.className = 'item';

			    return el;
			}

			// 마커를 생성하고 지도 위에 마커를 표시하는 함수입니다
			function addMarker(position, idx, title) {
			    var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_number_blue.png', // 마커 이미지 url, 스프라이트 이미지를 씁니다
			        imageSize = new kakao.maps.Size(36, 37),  // 마커 이미지의 크기
			        imgOptions =  {
			            spriteSize : new kakao.maps.Size(36, 691), // 스프라이트 이미지의 크기
			            spriteOrigin : new kakao.maps.Point(0, (idx*46)+10), // 스프라이트 이미지 중 사용할 영역의 좌상단 좌표
			            offset: new kakao.maps.Point(13, 37) // 마커 좌표에 일치시킬 이미지 내에서의 좌표
			        },
			        markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imgOptions),
			            marker = new kakao.maps.Marker({
			            position: position, // 마커의 위치
			            image: markerImage 
			        });

			    marker.setMap(map); // 지도 위에 마커를 표출합니다
			    markers.push(marker);  // 배열에 생성된 마커를 추가합니다

			    return marker;
			}

			// 지도 위에 표시되고 있는 마커를 모두 제거합니다
			function removeMarker() {
			    for ( var i = 0; i < markers.length; i++ ) {
			        markers[i].setMap(null);
			    }   
			    markers = [];
			}

			// 검색결과 목록 하단에 페이지번호를 표시는 함수입니다
			function displayPagination(pagination) {
			    var paginationEl = document.getElementById('pagination'),
			        fragment = document.createDocumentFragment(),
			        i; 

			    // 기존에 추가된 페이지번호를 삭제합니다
			    while (paginationEl.hasChildNodes()) {
			        paginationEl.removeChild (paginationEl.lastChild);
			    }

			    for (i=1; i<=pagination.last; i++) {
			        var el = document.createElement('a');
			        el.href = "#";
			        el.innerHTML = i;

			        if (i===pagination.current) {
			            el.className = 'on';
			        } else {
			            el.onclick = (function(i) {
			                return function() {
			                    pagination.gotoPage(i);
			                }
			            })(i);
			        }

			        fragment.appendChild(el);
			    }
			    paginationEl.appendChild(fragment);
			}

			// 검색결과 목록 또는 마커를 클릭했을 때 호출되는 함수입니다
			// 인포윈도우에 장소명을 표시합니다
			function displayInfowindow(marker, title) {
			    var content = '<div style="padding:5px;z-index:1;">' + title + '</div>';

			    infowindow.setContent(content);
			    infowindow.open(map, marker);
			}

			 // 검색결과 목록의 자식 Element를 제거하는 함수입니다
			function removeAllChildNods(el) {   
			    while (el.hasChildNodes()) {
			        el.removeChild (el.lastChild);
			    }
			}
			 
			 
			// 지도에서 선택한 장소 간단히 확인할 수 있게 선택한 장소 적어주기   
			function showSelectedPlaceInfo(title, address) {
				placeName = title;
				placeAddress = address;
				document.querySelector(".placeinfo--title").innerText = placeName;
				document.querySelector(".placeinfo--address").innerText = placeAddress;
			}
			
			// map 에서 장소 선택 후 confirm 버튼 누르면 선택한 장소에 대한 정보를 보여줘야 함 
			function showConfirmedPlace() {
				document.querySelector(".locationName h5").innerText = placeName + " - [ " + placeAddress + " ]";
			}
	</script>
	<script>
		// 모달창 지도 깨져보이는 것 고치기 위한 함수
		$(document).ready(function() {
			$("#mapModal").on('shown.bs.modal', function() {
				console.log("on");
				setTimeout(function() {
					console.log("works");
					map.relayout();
					map.setLevel(3);		// relayout 하고나면 맵이 전국 단위로 나오기에, 레벨 설정을 해준다.
				}, 10);
			});
			
			$("#searchBtn").on('click', function() { 	// map 검색하기버튼누르면 함수 실행 
				console.log("clicked");
				searchPlaces();
			});
			
			$("#confirmBtn").on('click', function() {
				$("#mapModal").modal('hide');
				showConfirmedPlace();
			});
		});
		
	</script>
	<script>
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