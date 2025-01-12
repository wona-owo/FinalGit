<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>신고내역</title>
<link rel="stylesheet" href="/resources/default.css">
<style>
/* 전체 컨테이너 스타일 */
.report-container {
    max-width: 80%;
    margin: 20px auto;
    padding: 20px;
}

/* 테이블 스타일 */
.report-container table {
    width: 100%;
    border-collapse: collapse;
    margin: 20px 0;
    font-size: 14px;
    text-align: center;
    color: #333;
}

.report-container th, 
.report-container td {
    border-bottom: 1px solid #ddd;
    padding: 12px;
}

/* 테이블 헤더 스타일 */
.report-container th {
    font-weight: bold;
    text-transform: uppercase;
    color: #666;
}

/* 테이블 데이터 스타일 */
.report-container td {
    background-color: #fff;
}

/* 링크 스타일 */
.report-container a {
    color: #5b9bd5;
    text-decoration: none;
    font-weight: bold;
}

.report-container a:hover {
    text-decoration: underline;
}

/* 드롭다운 버튼 스타일 */
.report-container .dropdown {
    position: relative;
    display: inline-block;
}

.report-container .dropdown-content {
    display: none;
    position: absolute;
    right: 0;
    background-color: #fff;
    min-width: 100px;
    box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
    z-index: 1;
    border: 1px solid #ddd;
    border-radius: 4px;
}

.report-container .dropdown-content a {
    color: #333;
    padding: 8px 12px;
    text-decoration: none;
    display: block;
    font-size: 14px;
}

.report-container .dropdown-content a:hover {
    background-color: #f1f1f1;
}

.report-container .dropdown:hover .dropdown-content {
    display: block;
}

/* 테이블 전체 정렬 */
body {
    background-color: #fafafa;
    margin: 0;
    padding: 0;
}

</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/member/sideMenu.jsp" %>
		
	<main>	
		<div class="report-container">
			<table border="1">
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
					<td><a href="#" class="report-link" data-content="${report.postContent}" data-post-no="${report.targetNo}">링크</a></td>
				</tr>
			</c:forEach>
			</table>
		</div>		
	</main>	
		
		<%-- 모달 창--%>
    <div id="modal-container">
        <%@ include file="/WEB-INF/views/member/postModal.jsp"%>
    </div>
		
</body>
</html>