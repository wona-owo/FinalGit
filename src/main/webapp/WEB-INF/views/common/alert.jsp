<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Alert</title>
</head>
<body>
    <script>
        // 알림 메시지 출력 후 이동
        window.onload = function() {
            alert("${message}");
            window.location.href = "${url}";
        };
    </script>
</body>
</html>