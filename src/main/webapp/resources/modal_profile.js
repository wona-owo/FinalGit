function createProfileHTML(){
    return `
    <div class="modal-backdrop-G" id="profileModalBackdrop" style="display: none;">
    <div class="modal-G" id="profileModal" style="display: none;">
        <div class="modal-content-G">
            <!-- 모달 제목 -->
            <h2>프로필 편집</h2>

            <div class="modal-body-G">
                <!-- 왼쪽 영역 -->
                <div class="modal-left-G">
                    <!-- 프로필 이미지 영역 -->
                    <div class="profile-image-container">
                        <img id="profileImagePreview"
                            src="${loginMember.userImage? loginMember.userImage
                                : '/resources/profile_file/default_profile.png'}"
                            alt="프로필 이미지" />
                    </div>
                    <!-- 이미지 변경 / 삭제 버튼 -->
                    <div class="image-btn-group">
                        <button id="btnChangeImage" class="btn">변경</button>
                        <button id="btnDeleteImage" class="btn btn-delete">삭제</button>
                        <!-- 파일 업로드 input (감춰둠) -->
                        <input type="file" id="userImage" name="userImage" accept="image/*"
                            style="display: none;" />
                    </div>

                    <!-- 아이디/이름 (읽기 전용) -->
                    <div class="info-group">
                        <label for="userId">아이디</label>
                        <input type="text" id="userId" class="modal-in" name="userId" value="${loginMember.userId}"
                            readonly/>
                    </div>
                    <div class="info-group">
                        <label for="userName">이름</label>
                        <input type="text" id="userName" class="modal-in" name="userName" value="${loginMember.userName}"
                            disabled/>
                    </div>
                    <button id="btnDeleteUser" class="btn btn-delete">탈퇴</button>
                </div>

                <!-- (2) 오른쪽 영역 -->
                <div class="modal-right-G">
                    <!-- 닉네임 + 중복체크 버튼 -->
                    <div class="form-group duplication-group">
                        <label for="userNickname">닉네임</label>
                        <div class="input-with-btn">
                            <input type="text" class="modal-in" id="userNickname" name="userNickname"
                                value="${loginMember.userNickname}" />
                            <button type="button" id="btnCheckNickname" class="btn btn-dup-check">
                                중복확인
                            </button>
                        </div>
                    </div>

                    <!-- 주소 -->
                    <div class="form-group">
                        <label for="userAddress">주소</label>
                        <input type="text" class="modal-in" id="userAddress" name="userAddress"
                            value="${loginMember.userAddress}" placeholder="OO시 OO구"/>
                    </div>

                    <!-- 이메일 -->
                    <div class="form-group">
                        <label for="userEmail">이메일<span id="invalidEmail"></span></label>
                        <input type="email" class="modal-in" id="userEmail" name="userEmail"
                            value="${loginMember.userEmail}" placeholder="aaa@example.co.kr"/>
                    </div>

                    <!-- 전화번호 + 중복체크 버튼 -->
                    <div class="form-group duplication-group">
                        <label for="userPhone">전화번호<span id="invalidPhone"></span></label>
                        <div class="input-with-btn">
                            <input type="text" class="modal-in" id="userPhone" name="userPhone"
                                value="${loginMember.userPhone}" placeholder="010-0000-0000"/>
                            <button type="button" id="btnCheckPhone" class="btn btn-dup-check">
                                중복확인
                            </button>
                        </div>
                    </div>

                    <!-- 버튼 영역 (수정, 취소) -->
                    <div class="button-area">
                        <button class="btn save-btn" id="saveBtn">수정</button>
                        <button class="btn cancel-btn" id="cancelBtn">취소</button>
                    </div>
                </div>
            </div> <!-- modal-body 끝 -->
        </div> <!-- modal-content 끝 -->
    </div> <!-- modal 끝 -->
</div>
    `;
}

// 선택된 프로필 이미지 파일 보관
let selectedProfileImageFile = null;

function openProfileModal(){
    // 1. 모달 HTML 문자열 생성
    const modalHTML = createProfileHTML();

    // 2. 임시로 div를 만들고, 그 안에 모달 HTML을 주입
    const tempDiv = document.createElement('div');
    tempDiv.innerHTML = modalHTML.trim();

    // 3. 실제 모달 요소(overlay)를 가져오기
    // (tempDiv 안에 있는 첫 번째 자식이 우리가 만든 .modal-overlay)
    const modalOverlay = tempDiv.firstChild;

    // 4. body에 모달 요소를 추가 
    $('#myfeed-main').append(modalOverlay);
    
    // 5. 모달 표시	
    $("#profileModalBackdrop").css("display", "block");
    $("#profileModal").css("display", "block");
    
    // (이벤트) 모달 바깥(배경) 클릭 시 닫기
    $("#profileModalBackdrop").on("click", function (event) {
        if (event.target === this) {
            closeProfileModal();
        }
    });

    // (이벤트) 취소 버튼
    $("#cancelBtn").on("click", closeProfileModal);
    
    // 모달 닫기 함수
    function closeProfileModal() {
        $("#profileModalBackdrop").remove(); // DOM에서 제거
    }
    
    // (이벤트) 이미지 변경 버튼 → file input 클릭
    $("#btnChangeImage").on("click", function () {
        $("#userImage").click();
    });
    
    // (이벤트) 파일 input 변경 시 → 미리보기
    $("#userImage").on("change", imageChange);

    // (이벤트) 이미지 삭제
    $("#btnDeleteImage").on("click", imageDelete);
    
     // (이벤트) 닉네임 중복확인
    $("#btnCheckNickname").on("click", checkNickname);

    // (이벤트) 전화번호 중복확인
    $("#btnCheckPhone").on("click", checkPhone);

    // (이벤트) 수정 버튼
    $("#saveBtn").on("click", profileUpdate);
    
    // (이벤트) 회원탈퇴 버튼
    $("#btnDeleteUser").on("click", deleteUser);
    
    // 이미지 변경
    function imageChange() {
        const fileInput = this;
        const file = fileInput.files[0];
        if (!file) return;

        // selectedProfileImageFile에 저장
        selectedProfileImageFile = file;

        // 미리보기
        const reader = new FileReader();
        reader.onload = (e) => {
            $("#profileImagePreview").attr("src", e.target.result);
        };
        reader.readAsDataURL(file);
            
        // 파일 선택 후 같은 파일을 다시 선택할 수 있도록 `value`를 초기화
        fileInput.value = "";
    }

    // 이미지 삭제
    function imageDelete() {
        if (!confirm("정말 이미지를 삭제하시겠습니까?")) return;

        // 기본이미지로 변경
        $("#profileImagePreview").attr("src", "/resources/profile_file/default_profile.png");
        
        // 초기화
        selectedProfileImageFile = null;
        
        // 파일 입력 요소 초기화
        $("#userImage").val("");
    }
    
    // 입력 정보 체크
    $(document).ready(function() {
        chkUserEmail();
        chkUserPhone();
    });
    
    //유효성 검증 변수
    let phoneVal = false;
    let emailVal = false;
    
    //중복체크 검증 변수 - insert가 아닌 update이기 때문에 처음에 true로 선언
    let chkDuplNick = true;
    let chkDuplPhone = true;
    
    //전화번호
    const userPhone = $("#userPhone");
    const phMessage =$("#invalidPhone");
    
    const phRegExp = /^0\d{2}-\d{3,4}-\d{4}$/;  //전화번호 패턴
    
    function chkUserPhone(){
        const value = $("#userPhone").val();
        
        if(phRegExp.test(value)){
            phMessage.text("");
            phMessage.css("color", "");
            phoneVal = true;
        }else{
            phMessage.text("올바른 형식이 아닙니다.");
            phMessage.css("color","red");
            phoneVal = false;
        }
    }
    
    userPhone.on("input", chkUserPhone);
    
    //이메일
    const userEmail = $("#userEmail");
    const emMessage =$("#invalidEmail");
    
    const emRegExp = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;  //이메일 패턴
    
    function chkUserEmail() {
        const value = $("#userEmail").val();
        if (emRegExp.test(value)) {
            emMessage.text("");
            emMessage.css("color", "");
            emailVal = true;
        } else {
            emMessage.text("올바른 형식이 아닙니다.");
            emMessage.css("color", "red");
            emailVal = false;
        }
    }
    
    userEmail.on("input", chkUserEmail);
    
    // 닉네임
    const userNickname = $("#userNickname");
    // 닉네임 입력 시, 중복체크 변수를 false로 변경
    userNickname.on('input', function(){
        chkDuplNick = false;
    });
    
    function checkNickname(){
        //입력값이 없는 경우
        if(!userNickname.val()){
            alert("닉네임을 입력해주세요");
            return;
        }
        
        $.ajax({
            url : "/member/nickDuplChk.kh", //중복검사 서블릿
            data :{ userNickname : userNickname.val()},
            type : "GET",
            
            success : function(res) {
                if(res == '1' && userNickname.val() !== currentNickname){
                    alert("이미 사용중인 닉네임입니다.")
                    chkDuplNick = false;
                }else{
                    alert("사용 가능한 닉네임입니다.")
                    chkDuplNick = true;
                }
            },
            error : function () {
                console.error("ajax 요청 실패!")
            }
        });
    }
    
    // 전화번호
    
    // 전화번호 입력 시, 중복체크 변수를 false로 변경
    userNickname.on('input', function(){
        chkDuplPhone = false;
    });
    
    function checkPhone(){
        //입력값이 없는 경우
        if(!userPhone.val()){
            alert("전화번호를 입력해주세요");
            return;
        }
        
        
        $.ajax({
            url : "/member/phoneDuplChk.kh", //중복검사 서블릿
            data :{ userPhone : userPhone.val()},
            type : "GET",
            
            success : function(res) {
                if(res == '1' && userPhone.val() !== currentUserPhone){
                    alert("이미 가입된 전화번호입니다.")
                    chkDuplPhone = false;
                }else{
                    alert("사용 가능한 전화번호입니다.")
                    chkDuplPhone = true;
                }
            },
            error : function () {
                console.error("ajax 요청 실패!")
            }
        });
    }
    
    // 프로필 업데이트
    
    // 수정 버튼 클릭 시 데이터 유효성 검사
    const userAddr = $("#userAddress");
    const userId = $("#userId");

    function profileUpdate(){
        //빈칸 검사 - 배열 저장
           const inputVal = [
            { field: userNickname, message: "닉네임을 입력하세요." },
            { field: userAddr, message: "주소를 입력하세요." },
            { field: userEmail, message: "이메일을 입력하세요." },
            { field: userPhone, message: "전화번호를 입력하세요." }
            ];
        
        //유효성 변수
        let isValid = false;
        
        //빈값 확인
        for(let i=0; i<inputVal.length; i++){	
            if(!inputVal[i].field.val().trim()){
                alert(inputVal[i].message);
                isValid = false;
                return;
            }		  
            isValid = true;
        }
        
        // 중복 검사 확인
        if (!chkDuplNick) {
            alert("닉네임 중복검사를 완료해주세요.");
            return;
        }
        if (!chkDuplPhone) {
            alert("전화번호 중복검사를 완료해주세요.");
            return;
        }
        
        //데이터 유효 검사
        isValid = phoneVal && 
                  emailVal && 
                  chkDuplNick && 
                  chkDuplPhone;
        
        //제출 - 유효성 검사가 끝난 후 
        if(isValid){
            const updatedData = {
                userId: userId.val().trim(),
                userNickname: userNickname.val().trim(),
                userAddress: userAddr.val().trim(),
                userEmail: userEmail.val().trim(),
                userPhone: userPhone.val().trim(),
                userImage: selectedProfileImageFile, // 파일은 변수로 관리
            };
            
            // 전달할 데이터들을 formData에 세팅
            const formData = new FormData();
            formData.append("userId", userId.val());
            formData.append("userNickname", userNickname.val());
            formData.append("userAddress", userAddr.val());
            formData.append("userEmail", userEmail.val());
            formData.append("userPhone", userPhone.val());

            // 이미지 파일을 업로드 했을 시 formData에 세팅
            if(selectedProfileImageFile){
                formData.append("file", selectedProfileImageFile);
            }

            $.ajax({
                url : "/member/updateProfile.kh",
                type: "post",
                data: formData,
                processData: false, // 데이터를 쿼리 문자열로 변환하지 않음
                contentType: false, // 콘텐츠 타입을 설정하지 않음 (브라우저가 자동으로 설정)
                success: function(updatedMember){
                    if(updatedMember){
                        $("#userNicknameDisplay").text(updatedMember.userNickname);
                        $("#profileImage").attr("src", updatedMember.userImage || "/resources/profile_file/default_profile.png");

                        alert("프로필이 업데이트되었습니다");
                    }else{
                        alert("프로필 업데이트에 실패했습니다.");
                    }
                    closeProfileModal();
                },
                error: function(){
                    console.log('ajax 통신 오류');
                }
            });
        }else{
             alert("유효하지 않은 입력값이 있습니다. 다시 확인해주세요.")
             return;
        }
    }
    
    // 회원탈퇴
    function deleteUser(){
        if (!confirm("정말 회원 탈퇴를 하시겠습니까?")) return;
        
        window.location.href = "/member/userUnlink.kh";
    }
}