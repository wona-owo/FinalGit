<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
<link rel="stylesheet" href="/resources/default.css">
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
	rel="stylesheet">
<!-- <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script> -->
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
									<img class="profileImage"
				                            src="${not empty loginMember.userImage ? loginMember.userImage : '/resources/profile_file/default_profile.png'}"
				                            alt="프로필 이미지" />
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
						
						<!-- 게시글 좋아요 버튼 -->
						<div class="like-btn post-like" data-id="${postNo}" data-user-no="${sessionScope.loginMember.userNo}" data-liked="false">
						    <i class="fa-regular fa-heart"></i>
						    <span class="like-count">0</span>
						</div>
			            
					</div>

					<%-- 댓글 영역 --%>
				
					<div class="comment-section">
						<div class="comment-list">
							<%-- 동적으로 댓글이 추가될 위치 --%>
						</div>
					</div>
					
					
					<div class="comment-form-wrapper">
					    <div class="reply-target" style="display: none;">
					        <span id="reply-target-text"></span>
					        <button class="cancel-reply">취소</button>
					    </div>
					    
					    <form id="cmtForm" action="/post/cmtWrite.kh" method="post" enctype="multipart/form-data">
					        <input type="hidden" name="userNo" value="${sessionScope.loginMember.userNo}">
					        <input type="hidden" id="parentNo" value="0">
					        <div class="comment-form">
					            <textarea class="comment-input" placeholder="댓글 달기..."></textarea>
					            <button class="submit-comment">
					                <i class="fa-solid fa-comment"></i>
					            </button>
					        </div>
					    </form>
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
        		   <button class="story-nav-btn story-prev-btn previous">
                  	 <span class="material-icons nav-icons">navigate_before</span>
                   </button>
		            <img id="current-image" src="" alt="thumbnail">
		            <button class="story-nav-btn story-next-btn next">
                    	<span class="material-icons nav-icons">navigate_next</span>
                   </button>
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
		        
		        // 다른 함수에도 postNo 전달
		        handlePostLike(postNo);
		        handleCommentLike(); 
		        loadPostLikeStatus(postNo);
		       
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
			
		    //댓글 불러오기
		    function callComment(postNo) {
			    $.ajax({
			        url: "/post/comment.kh",
			        type: "get",
			        dataType: "json",
			        data: { postNo: postNo },
			        success: function (res) {
			            const userNo = $("input[name='userNo']").val(); // 로그인 사용자 ID
			            $(".comment-list").empty(); // 댓글 목록 초기화
			
			            res.forEach(function (comment) {
			                let commentHtml = '<div class="comment" id="comment-' + comment.commentNo + '">';
			                commentHtml += '<p><strong>' + comment.userNickname + '</strong>: ' + comment.commentContent + '</p>';
			
			                // 댓글 좋아요 버튼 추가
			                commentHtml += '<div class="like-btn comment-like" data-id="' + comment.commentNo + '" data-liked="' + comment.isLiked + '">';
			                if (comment.isLiked) {
			                    commentHtml += '<i class="fa-solid fa-heart"></i>';
			                } else {
			                    commentHtml += '<i class="fa-regular fa-heart"></i>';
			                }
			                commentHtml += '<span class="like-count">' + comment.likeCount + '</span>';
			                commentHtml += '</div>';
			
			                // 수정/삭제 버튼 추가 (작성자만)
			                if (comment.userNo == userNo) {
			                    commentHtml += '<button class="edit-comment" data-id="' + comment.commentNo + '">수정</button>';
			                    commentHtml += '<button class="delete-comment" data-id="' + comment.commentNo + '">삭제</button>';
			                }
			
			                // 답글 영역 추가
			                commentHtml += '<a href="#" class="reply-link" data-id="' + comment.commentNo + '">답글 달기</a>';
			                commentHtml += '<div class="reply" id="reply-' + comment.commentNo + '"></div>';
			                commentHtml += '</div>';
			
			                if (comment.parentNo == 0) {
			                    $(".comment-list").append(commentHtml); // 부모 댓글 추가
			                } else {
			                    let replyHtml = '<div class="comment-reply" id="reply-' + comment.commentNo + '">';
			                    replyHtml += '<p> ↳ <strong>' + comment.userNickname + '</strong>: ' + comment.commentContent + '</p>';
			
			                    // 답글 좋아요 버튼 추가
			                    replyHtml += '<div class="like-btn comment-like" data-id="' + comment.commentNo + '" data-liked="' + comment.isLiked + '">';
			                    if (comment.isLiked) {
			                        replyHtml += '<i class="fa-solid fa-heart"></i>';
			                    } else {
			                        replyHtml += '<i class="fa-regular fa-heart"></i>';
			                    }
			                    replyHtml += '<span class="like-count">' + comment.likeCount + '</span>';
			                    replyHtml += '</div>';
			
			                    // 수정/삭제 버튼 추가 (작성자만)
			                    if (comment.userNo == userNo) {
			                        replyHtml += '<button class="edit-comment" data-id="' + comment.commentNo + '">수정</button>';
			                        replyHtml += '<button class="delete-comment" data-id="' + comment.commentNo + '">삭제</button>';
			                    }
			                    replyHtml += '</div>';
			
			                    $('#reply-' + comment.parentNo).append(replyHtml); // 답글 추가
			                }
			            });
			            
			            updateCommentLikeStatus();
			        },
			        error: function (xhr, status, error) {
			            console.error("AJAX 통신 오류:", error);
			        },
			    });
			
			      

		    }

		 

		 // 댓글 작성
		    let currentParentNo = 0;

		    $("#cmtForm").on("submit", function (e) {
		        e.preventDefault(); // 기본 동작 막기

		        const commentInput = $(".comment-input").val().trim();
		        const userNo = $("input[name='userNo']").val();
		        const postNo = $(".post-grid").data("id"); // 게시글 ID 가져오기
		        const submitButton = $(".submit-comment"); // 제출 버튼 선택

		        if (!commentInput) return; // 입력 값이 없으면 종료

		        // 버튼 비활성화
		        submitButton.prop("disabled", true);

		        $.ajax({
		            url: "/post/cmtWrite.kh",
		            method: "POST",
		            contentType: "application/json",
		            data: JSON.stringify({
		                commentContent: commentInput,
		                userNo: userNo,
		                postNo: postNo,
		                parentNo: currentParentNo
		            }),
		            success: function (response) {
		                if (response.success) {
		                    callComment(postNo); // 댓글 목록 갱신
		                    $(".comment-input").val(""); // 입력 필드 초기화

		                    // 답글 대상 초기화
		                    currentParentNo = 0;
		                    $("#parentNo").val(0);
		                    $(".reply-target").hide();
		                    $("#reply-target-text").text("");
		                } else {
		                    alert(response.message);
		                }
		            },
		            error: function () {
		                alert("댓글 작성 중 오류가 발생했습니다.");
		            },
		            complete: function () {
		                // 버튼 활성화
		                submitButton.prop("disabled", false);
		            }
		        });
		    });

		 // 답글 달기
		    $(document).on("click", ".reply-link", function (e) {
		        e.preventDefault();

		        const parentNo = $(this).data("id"); // 부모 댓글 ID 가져오기
		        const userNickname = $("#comment-" + parentNo).find("strong").first().text().trim(); // 부모 댓글 닉네임 가져오기

		        currentParentNo = parentNo; // 현재 부모 댓글 ID 설정
		        $("#parentNo").val(parentNo); // 숨겨진 필드에 부모 댓글 ID 설정

		        // 답글 대상 표시
		        $("#reply-target-text").text(userNickname + "님에게 답글 작성 중");
		        $(".reply-target").show(); // 답글 대상 보이기
		    });

		 
		//삭제 기능
		  $(document).on("click", ".delete-comment", function () {
			    const commentNo = $(this).data("id");
			    const postNo = $(".post-grid").data("id"); // 현재 게시글 ID 가져오기
				
			    if (confirm("정말로 삭제하시겠습니까?")) {
			        $.ajax({
			            url: "/post/cmtDelete.kh",
			            method: "GET",
			            data: { commentNo: commentNo },
			            success: function (response) {
			                // 서버 응답 데이터 확인
			                console.log(response);
			
			                if (response.success) {
			                    alert(response.message);
			                    callComment(postNo); // 댓글 목록 갱신
			                } else {
			                    alert(response.message);
			                }
			            },
			            error: function (xhr, status, error) {
			                console.error("AJAX 요청 오류:", error);
			                alert("댓글 삭제 중 오류가 발생했습니다.");
			            }
			        });
			    }
			});


		// 댓글 수정 버튼 클릭 시
		  $(document).on("click", ".edit-comment", function () {
		      const $commentDiv = $(this).closest(".comment, .comment-reply"); // 댓글 영역
		      const commentNo = $(this).data("id"); // 댓글 번호

		      // 이미 수정 중인 상태라면 중복 실행 방지
		      if ($commentDiv.find(".edit-wrapper").length > 0) {
		          return;
		      }

		      // 수정 중 입력창 추가 (기존 내용 표시하지 않음)
		      let editHtml = '<div class="edit-wrapper">';
		      editHtml += '<textarea class="edit-input" style="width: 100%; height: 80px; resize: none;" placeholder="수정할 내용을 입력해주세요."></textarea>';
		      editHtml += '<button class="save-comment" data-id="' + commentNo + '">저장</button>';
		      editHtml += '<button class="cancel-edit">취소</button>';
		      editHtml += '</div>';
		      $commentDiv.append(editHtml);
		  });

		// 댓글 수정 저장
		  $(document).on("click", ".save-comment", function () {
		      const $commentDiv = $(this).closest(".comment, .comment-reply"); // 댓글 영역
		      const commentNo = $(this).data("id"); // 댓글 번호
		      const newContent = $commentDiv.find(".edit-input").val().trim(); // 새로 입력된 댓글 내용
		      const userNo = $("input[name='userNo']").val(); // 로그인 사용자 ID 가져오기
		      const userNickname = $commentDiv.find("strong").text(); // 기존 닉네임 가져오기

		      if (!newContent) {
		          alert("내용을 입력해주세요.");
		          return;
		      }

		      // AJAX 요청
		      $.ajax({
		          url: "/post/cmtUpdate.kh", // 댓글 수정 URL
		          method: "POST",
		          contentType: "application/json",
		          data: JSON.stringify({
		              commentNo: commentNo,
		              commentContent: newContent,
		              userNo: userNo
		          }),
		          success: function (response) {
		              if (response.success) {
		                  // 댓글 내용 업데이트
		                  const updatedHtml = '<strong>' + userNickname + '</strong>: ' + newContent;
		                  $commentDiv.find("p").html(updatedHtml); // 닉네임과 수정된 댓글 내용 추가

		                  // 수정 창 제거
		                  $commentDiv.find(".edit-wrapper").remove();
		              } else {
		                  alert(response.message);
		              }
		          },
		          error: function () {
		              alert("댓글 수정 중 오류가 발생했습니다.");
		          }
		      });
		  });

		  // 댓글 수정 취소
		  $(document).on("click", ".cancel-edit", function () {
		      const $commentDiv = $(this).closest(".comment, .comment-reply");
		      $commentDiv.find(".edit-wrapper").remove(); // 수정 창 제거
		  });
		 
			 //답글 취소
			    $(document).on("click", ".cancel-reply", function () {
			        currentParentNo = 0; // 부모 댓글 ID 초기화
			        $("#parentNo").val(0); // 숨겨진 필드 초기화
	
		        // 답글 대상 숨기기
		        $(".reply-target").hide(); // 완전히 숨김
		        $("#reply-target-text").text(""); // 텍스트 초기화
		    });
	
		
			 // 게시글 좋아요 처리
			    function handlePostLike(postNo) {
			        $(document).on("click", ".post-like", function () {
			            const $btn = $(this);
			            const userNo = $btn.data("user-no") || $("input[name='userNo']").val();
			            const isLiked = $btn.data("liked"); // 현재 좋아요 상태
			            const url = isLiked ? "/post/postLikeDel.kh" : "/post/postLike.kh";

			            // 중복 요청 방지 플래그 확인
			            if ($btn.data("loading")) return;

			            if (!postNo || !userNo) {
			                console.error("[ERROR] postNo 또는 userNo가 누락되었습니다.");
			                return;
			            }

			            // 요청 중 플래그 설정
			            $btn.data("loading", true);

			            // 좋아요 등록/취소 AJAX 호출
			            $.ajax({
			                url: url,
			                type: "GET",
			                data: { targetNo: postNo, userNo: userNo, targetType: "P" },
			                success: function (response) {
			                    if (response === "success") {
			                        const likeCount = $btn.find(".like-count");
			                        const currentCount = parseInt(likeCount.text()) || 0;

			                        // UI 업데이트
			                        if (isLiked) {
			                            likeCount.text(Math.max(currentCount - 1, 0));
			                        } else {
			                            likeCount.text(currentCount + 1);
			                        }

			                        $btn.data("liked", !isLiked); // 좋아요 상태 업데이트
			                        $btn.find("i").toggleClass("fa-solid", !isLiked).toggleClass("fa-regular", isLiked);
			                    } else {
			                        alert("좋아요 업데이트에 실패했습니다.");
			                    }
			                },
			                error: function () {
			                    console.error("[ERROR] 좋아요 등록/취소 AJAX 요청 실패");
			                },
			                complete: function () {
			                    // 요청 완료 후 플래그 해제
			                    $btn.data("loading", false);
			                },
			            });
			        });
			    }

			 
			
			 
			// 게시글 좋아요 상태 초기화
			function loadPostLikeStatus(postNo) {
			    const $likeBtn = $(".post-like"); // 좋아요 버튼
			    const userNo = $("input[name='userNo']").val(); // 로그인 사용자 ID
			
			    if (!postNo || !userNo) {
			        console.error("게시글 ID 또는 사용자 ID가 누락되었습니다.");
			        return;
			    }
			
			    // 서버에서 좋아요 상태 확인
			    $.ajax({
			        url: "/post/isLiked.kh", // 서버에서 좋아요 상태 확인
			        type: "GET",
			        data: { targetNo: postNo, userNo: userNo, targetType: "P" }, // targetType: "P"는 게시글
			        success: function (isLikedResponse) {
			            const isLiked = isLikedResponse === "true"; // 서버 응답이 "true"일 경우 좋아요 상태
			            $likeBtn.data("liked", isLiked); // 좋아요 상태를 data 속성에 저장
			            $likeBtn.attr("data-liked", isLiked); // HTML 속성 업데이트
			
			            // 좋아요 상태에 따라 아이콘 클래스 설정
			            $likeBtn.find("i")
			                .toggleClass("fa-solid", isLiked) // 활성화 상태
			                .toggleClass("fa-regular", !isLiked); // 비활성화 상태
			        },
			        error: function () {
			            console.error("좋아요 상태 초기화 실패");
			        }
			    });
			
			    // 서버에서 좋아요 개수 확인
			    $.ajax({
			        url: "/post/postlikeCnt.kh", // 좋아요 개수 확인
			        type: "GET",
			        data: { targetNo: postNo },
			        success: function (likeCountResponse) {
			            const likeCount = parseInt(likeCountResponse) || 0;
			            $likeBtn.find(".like-count").text(likeCount); // 좋아요 개수 업데이트
			        },
			        error: function () {
			            console.error("좋아요 개수 초기화 실패");
			        }
			    });
			}

				
			  
				// 댓글 좋아요 처리						
				function handleCommentLike() {
					// 좋아요 버튼 클릭 이벤트 수정
					$(document).on("click", ".comment-like", function () {
					    const $btn = $(this);
					    const targetNo = $btn.data("id"); // 댓글 또는 답글 고유 ID
					    const userNo = $("input[name='userNo']").val();
					    const isLiked = $btn.data("liked");
					    const url = isLiked ? "/post/commentLikeDel.kh" : "/post/commentLike.kh";

					    $.ajax({
					        url: url,
					        type: "GET",
					        data: { targetNo: targetNo, userNo: userNo, targetType: "C" },
					        success: function (response) {
					            if (response === "success") {
					                const likeCount = $btn.find(".like-count");
					                const currentCount = parseInt(likeCount.text()) || 0;
					                const newCount = isLiked ? Math.max(currentCount - 1, 0) : currentCount + 1;

					                // 좋아요 상태 및 UI 업데이트
					                $btn.data("liked", !isLiked);
					                $btn.attr("data-liked", !isLiked); // DOM 속성 업데이트
					                $btn.find("i").toggleClass("fa-solid", !isLiked).toggleClass("fa-regular", isLiked);
					                likeCount.text(newCount);
					            } else {
					                alert("좋아요 처리 실패");
					            }
					        },
					        error: function () {
					            console.error("좋아요 요청 실패");
					        }
					    });
					});

				}

		
			// 댓글 좋아요 상태 및 개수 초기화
			function updateCommentLikeStatus() {
			    $(".comment-like").each(function () {
			        const $btn = $(this);
			        const commentNo = $btn.data("id"); // 댓글/답글 고유 ID
			        const userNo = $("input[name='userNo']").val();
			
			        if (!commentNo || !userNo) return;
			
			        // 서버에서 개별 좋아요 상태 확인
			        $.ajax({
			            url: "/post/isLiked.kh",
			            type: "GET",
			            data: { targetNo: commentNo, userNo: userNo, targetType: "C" },
			            success: function (isLikedResponse) {
			                const isLiked = isLikedResponse === "true";
			
			                // 좋아요 상태 및 UI 업데이트
			                $btn.data("liked", isLiked);
			                $btn.attr("data-liked", isLiked);
			                $btn.find("i").toggleClass("fa-solid", isLiked).toggleClass("fa-regular", !isLiked);
			            },
			            error: function () {
			                console.error("[ERROR] 좋아요 상태 초기화 실패");
			            }
			        });
			
			        // 서버에서 좋아요 개수 확인
			        $.ajax({
			            url: "/post/commentLikeCnt.kh",
			            type: "GET",
			            data: { targetNo: commentNo },
			            success: function (likeCountResponse) {
			                const likeCount = parseInt(likeCountResponse) || 0;
			                $btn.find(".like-count").text(likeCount); // 좋아요 개수 업데이트
			            },
			            error: function () {
			                console.error("[ERROR] 좋아요 개수 초기화 실패");
			            }
			        });
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