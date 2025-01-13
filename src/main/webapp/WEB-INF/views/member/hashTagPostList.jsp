<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel ="stylesheet"  href="/resources/default.css">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<%--해시태그--%>
<script src="https://cdn.jsdelivr.net/npm/@yaireo/tagify"></script>
<script src="https://cdn.jsdelivr.net/npm/@yaireo/tagify/dist/tagify.polyfills.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/@yaireo/tagify/dist/tagify.css" rel="stylesheet" type="text/css" />
<style>
/* 전체 컨테이너 스타일 */
.hashTags-container {
    margin: 0 auto;      /* 가운데 정렬 */
    padding: 20px 0;
}

/* 상단 해시태그명 영역 */
.hashName {
	width: 920px;
    text-align: center;
    margin-bottom: 10px;
}

.hashName #hashText {
    display: inline-block; /* block으로 쓰셔도 되고, inline-block으로 바꿔도 됨 */
    font-size: 24px;
    font-weight: bold;
    margin-bottom: 8px;
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/member/sideMenu.jsp" %>
	<main>
		<div class="hashTags-container">
			<div class="hashName">
				<span id="hashText">해시태그 : #${hashName}</span>
			</div>
			<div class="post-container">
		   		<c:forEach var="post" items="${post}">
		   			<div class="post-grid" data-id="${post.postNo}">
		   				<img class="feed-thumbnail" src="/resources/post_file/${post.postFileName}" alt="thumbnail">
		   				<p class="hidden-post-content" style="display: none;">${post.postContent}</p>			
		   			</div>
		   		</c:forEach>
		    </div>
		</div>
	</main>
	<%@ include file="/WEB-INF/views/member/postModal.jsp" %>
	
	<%@ include file="/WEB-INF/views/member/rightSideMenu.jsp" %>
	
</body>
</html>