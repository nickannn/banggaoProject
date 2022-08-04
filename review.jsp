<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Banggao review</title>
<link rel="stylesheet" href="css/banggao.css">
<link href="<c:url value="/css/bootstrap.min.css" />" rel="stylesheet">

</head>
<body>
	<div class="navbar">
        <div class="container">
            <a class="name" href="index.html">BANGGAO</a>
            <nav>
            <ul class="nav">
                <li><a href="/index.html">Home</a></li>
                <li><a href="#">Login</a></li>
                <li><a href="/about.html">About</a></li>
                <li><a href="/contact.html">Contact</a></li>
            </ul>
        </nav>
        </div>
    </div>
    
    
    <form action="<c:url value="/reviewAdd" />" method="post">
    <br/><br/><br/>
           <div class="form-group form-group-lg">
                <label class="control-label">내용을 작성해주세요 :)</label>
                <input name="revName" type="text" id="name" class="form-control" placeholder="이름:)">
                <!-- <input name="revContext" type="text" id="context" class="form-control" placeholder="내용:)"> -->
                <textarea name="revContext" id="name" cols="30" rows="10" placeholder="내용:)" ></textarea>
            </div>
                <button type="submit" class="form-submit">등록</button>
    </form>
   
    
    <div class="review-list">
    	<h1 class ="review-Title">BoardList </h1>
    <table class="review-table">
    	<tr>
    		<td class="table-name">Name</td>
    		<td class="table-context">Context</td>
    		<td class="table-regDate">Date </td>
    	</tr>
    	<c:if test="${not empty reviewList}">
	    	<c:forEach var = "i" begin="0" end = "${reviewList.size() - 1}" >
		    	<tr>
		    		<td>${reviewList.get(i).getRevName() }</td>
		    		<td>${reviewList.get(i).getRevContext()}</td>
					<td>${reviewList.get(i).getRegDate()}</td>
		    	</tr>    	
	    	</c:forEach>
        </c:if>
    </table>
    
    
    </div>

</body>
</html>