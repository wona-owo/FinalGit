<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/resources/default.css">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
	rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<%--해시태그--%>
<script src="https://cdn.jsdelivr.net/npm/@yaireo/tagify"></script>
<script
	src="https://cdn.jsdelivr.net/npm/@yaireo/tagify/dist/tagify.polyfills.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/@yaireo/tagify/dist/tagify.css"
	rel="stylesheet" type="text/css" />
</head>
<body>

	<%-- 포스트 조회 모달창 --%>
	<div class="modal">
		<div class="modal-place">
			<div class="modal-contents">
				<div class="modal-image">
					<%-- 클릭한 게시글의 이미지를 동적으로 삽입 --%>
				</div>

				<div class="modal-body">
					<div class="post-section">
						<div class="top">
							<div class="modal-user">
								<div class="profile-frame" id="modal-profile">
									<img id="profileImagePreview" alt="프로필 이미지" />
								</div>
								<p>${loginMember.userNickname}</p>
							</div>
							<div class="modal-buttons">
								<i class="fa-solid fa-pen" id="post-update"></i> <i
									class="fa-solid fa-trash" id="post-delete"></i> <a href="#"
									class="modal-close">X</a>
							</div>
						</div>

						<div class="post-content">
							<div class="post-content-text"></div>
							<div class="post-content-hashtag">
								<input name="tags" readonly />
							</div>
						</div>
					</div>

					<%-- 댓글 영역 --%>
				
					<div class="comment-section">
						<div class="comment-list">
							<%-- 동적으로 댓글이 추가될 위치 --%>
						</div>
					</div>

					<div class="comment-form">
						<textarea class="comment-input" placeholder="댓글달기..."></textarea>
						<button class="submit-comment">
							<i class="fa-solid fa-comment"></i>
						</button>
					</div>

				</div>
			</div>
		</div>
	</div>




	<script>    		
		$(document).ready(function () {
		    // 콘텐츠 모달
		    $(".feed-thumbnail").on("click", function () {
		        const postGrid = $(this).closest(".post-grid"); // 클릭된 썸네일의 부모 요소
		        let postNo = postGrid.data("id"); // 게시글 ID
		        const postContent = postGrid.find(".hidden-post-content").text(); // 숨겨진 콘텐츠 가져오기
	
		        // 초기 모달 설정
		        $(".modal").css("display", "block");
		        $(".modal .modal-image").html(`
		            <div class="previous">◀</div>
		            <img id="current-image" src="" alt="thumbnail">
		            <div class="next">▶</div>
		        `);
		        $(".modal .post-content-text").text(postContent);
	
		        // 이미지 슬라이드 호출
		        imgSlide(postNo);
		    });
	
		    // 이미지 슬라이드 함수
		    function imgSlide(postNo) {
		        $.ajax({
		            url: "/post/imgLists.kh",
		            method: "get",
		            data: { postNo: postNo },
		            success: function (res) {
		                let imgIndex = 0; // 초기 인덱스
		                const totalImages = res.length;
	
		                // 첫 이미지 설정
		                $("#current-image").attr("src", "/resources/post_file/" + res[imgIndex]);
	
		                // 이벤트 핸들러
		                $(".previous").off("click").on("click", function () {
		                    if (imgIndex > 0) {
		                        imgIndex--;
		                        $("#current-image").attr("src", "/resources/post_file/" + res[imgIndex]);
		                        updateButtonState();
		                    }
		                });
	
		                $(".next").off("click").on("click", function () {
		                    if (imgIndex < totalImages - 1) {
		                        imgIndex++;
		                        $("#current-image").attr("src", "/resources/post_file/" + res[imgIndex]);
		                        updateButtonState();
		                    }
		                });
	
		                // 버튼 상태 업데이트
		                updateButtonState();
	
		                function updateButtonState() {
		                    $(".previous").css("visibility", imgIndex === 0 ? "hidden" : "visible");
		                    $(".next").css("visibility", imgIndex === totalImages - 1 ? "hidden" : "visible");
		                }
		            },
		            error: function () {
		                console.error("AJAX 통신 에러 발생");
		            },
		        });
		    }
			
		    
		    // 게시글 클릭 시 해당 게시글 ID로 데이터 호출
		    $(".feed-thumbnail").on("click", function () {
		    	
		        let postNo = $(this).closest(".post-grid").data("id"); // 게시글 ID 가져오기
		       
		        if (!postNo) {
		            console.error("게시글 ID를 찾을 수 없습니다.");
		            return;
		        }
		        callHashtag(postNo); // 해시태그 불러오기
		        callComment(postNo); //댓글 불러오기
		        
		        
		    });
	
		    
		    
		    // 해시태그 불러오기
		    function callHashtag(postNo) {
		        $.ajax({
		            url: "/post/hashtags.kh", // 서버 요청 URL
		            method: "GET", // 요청 방식
		            data: { postNo: postNo }, // 서버에 전달할 데이터
		            success: function (res) {
		                const tagsString = res.join(", "); // 콤마로 구분된 문자열로 변환
		                const input = document.querySelector('input[name="tags"]');
	
		                if (!input) {
		                    console.error("태그 입력 필드를 찾을 수 없습니다.");
		                    return;
		                }
	
		                input.value = tagsString;
	
		                // Tagify 초기화 - 이미 초기화된 경우 중복 방지
		                if (!input._tagify) {
		                    new Tagify(input, {
		                        readOnly: true,
		                        delimiters: ", ", // 콤마와 공백으로 태그 구분
		                    });
		                } else {
		                    input._tagify.destroy();
		                    new Tagify(input, {
		                        readOnly: true,
		                        delimiters: ", ",
		                    });
		                }
		            },
		            error: function () {
		                console.error("AJAX 통신 오류 발생!");
		            },
		        });
		    }
		
		    function callComment(postNo) {
		        $.ajax({
		            url: "/post/comment.kh", // 서버 URL
		            type: "get",
		            dataType: "json", // 서버 응답 데이터 타입
		            data: { postNo: postNo }, // 요청 데이터
		            success: function (res) {
		                console.log("댓글 데이터:", res);

		                // 댓글 영역 초기화
		                $(".comment-list").empty();

		                // 댓글 데이터 반복 처리
		                res.forEach(function (comment) {
		                    // 부모 댓글 처리
		                    if (comment.parentNo == 0) {
		                        $(".comment-list").append(
		                            `<div class="comment" id="comment-` + comment.commentNo + `">
		                                <p>
		                                    <strong>` + comment.userNickname + `</strong>: ` + comment.commentContent + `
		                                </p>
		                                <div class="reply" id="reply-` + comment.commentNo + `">
		                                    <!-- 답글 추가될 영역 -->
		                                </div>
		                            </div>`
		                        );
		                    } 
		                    // 답글 처리
		                    else {
		                        $(`#reply-` + comment.parentNo).append(
		                            `<p> ↳ <strong>` + comment.userNickname + `</strong>: ` + comment.commentContent + `</p>`
		                        );
		                    }
		                });

		                // 최종 렌더링 결과 확인
		                console.log("최종 렌더링된 DOM:", $(".comment-list").html());
		            },
		            error: function (xhr, status, error) {
		                console.error("AJAX 통신 오류:", error);
		            },
		        });
		    }

		    
		    

		    // 포스트 조회 닫기
		    $(".modal-close").on("click", function () {
		        $(".modal").css("display", "none");
		    });
	
		    
		});
		
	
	</script>


</body>
</html>