<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신고내역</title>
<link rel="stylesheet" href="/resources/default.css">
</head>
<body>
	<%@ include file="/WEB-INF/views/member/sideMenu.jsp" %>
		
	<main>	
		<div class="report-container">
				<tr>
					<td>아이디</td>
					<td>이름</td>
					<td>사유</td>
					<td>유형</td>					
					<td>게시글</td>					
				</tr>
				
			<c:forEach var="report" items="${report}">
				<tr>
					<td>${report.userId}</td>
					<td>${report.userName}</td>
					<td>${report.reportReason}</td>
					<td>
						<c:if test="${report.targetType == 'C'}">
							댓글
						</c:if>
						<c:if test="${report.targetType == 'P'}">
							게시글
						</c:if>
					</td>
					<td><a href="#" data-post-no="${report.targetNo}">링크</a></td>
				</tr>
				
				
			</c:forEach>
		</div>
		
	</main>	
		
</body>
</html>