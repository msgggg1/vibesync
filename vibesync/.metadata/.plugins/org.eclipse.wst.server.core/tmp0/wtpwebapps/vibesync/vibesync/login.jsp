<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"
	integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo="
	crossorigin="anonymous"></script>
<link
	href="https://fonts.googleapis.com/css2?family=National+Park:wght@200..800&display=swap"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Cal+Sans&display=swap"
	rel="stylesheet">
<link rel="icon" href="./sources/favicon.ico">
<title>VibeSync Login</title>
<link rel="stylesheet" href="./css/login.css">
</head>

<body ondragstart="return false" ondrop="return false"
	onselectstart="return false">
	<canvas id="starfield"></canvas>

	<div class="container">
		<div id="logo">
			<img src="./sources/logo1.png" alt="VibeSync 로고" width="30%">
		</div>

		<div id="login">
			<div id="inner_logo">
				<img src="./sources/login/footer_logo.png" alt="VibeSync 로고"
					style="width: 150px; filter: drop-shadow(-1px 0px 0px #000) drop-shadow(-1px 0px 0px #000) drop-shadow(-1px 0px 0px #000) drop-shadow(1px 0px 0px #000) drop-shadow(0px 1px 0px #000);">
			</div>
			<div class="login-wrapper">
				<div id="findYourVibeSync">
					Find<br>Your<br> <span class="highlight">VibeSync</span><br>
					<br>
				</div>

				<!-- <div id="loginFormContainer"> -->
				<div id="loginFormContainer"
					style="${formToShow eq 'signUp' ? 'display:none;' : 'display:flex;'}">
					<form action="<%=request.getContextPath()%>/vibesync/user.do"
						method="post" id="loginForm">
						<%-- action을 login.jsp 또는 현재 페이지로 명시 --%>
						<%-- POST 요청 시 login/signup 구분 --%>
						<input type="hidden" name="accessType" value="login">
						
						<%-- 비밀번호 재설정 요청 메시지 --%>
				        <c:if test="${ loginMessage != null && !loginMessage.isEmpty() }">
				            <div class="form-notice"> <%-- 기본 파란색 스타일 --%>
				                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
				                    viewBox="0 0 24 24" fill="none" stroke="currentColor"
				                    stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
				                    class="notice-icon">
				                    <circle cx="12" cy="12" r="10"></circle>
				                    <line x1="12" y1="16" x2="12" y2="12"></line>
				                    <line x1="12" y1="8" x2="12.01" y2="8"></line>
				                </svg>
				                <p>${ loginMessage }</p>
				            </div>
				        </c:if>

						<%-- 회원가입 성공 메시지 --%>
						<c:if
							test="${ signupSuccessForDisplay != null && !signupSuccessForDisplay.isEmpty()}">
							<div class="form-notice form-notice-success">
								<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
									viewBox="0 0 24 24" fill="none" stroke="currentColor"
									stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
									class="notice-icon">
            					<path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
            					<polyline points="22 4 12 14.01 9 11.01"></polyline>
        						</svg>
								<p>${ signupSuccessForDisplay }</p>
							</div>
						</c:if>

						<label for="userId" class="sr-only">이메일</label> <input
							type="email" id="userId" name="userId" placeholder="Email"
							required value="${ rememberedEmail }"> <label
							for="userPw" class="sr-only">비밀번호</label> <input type="password"
							id="userPw" name="userPw" placeholder="Password" required>

						<%-- 로그인 에러 메시지 --%>
						<c:if test="${ loginErrorForDisplay != null && !loginErrorForDisplay.isEmpty() }">
						    <div class="form-notice form-notice-error">
						        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="notice-icon">
						            <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
						            <line x1="12" y1="9" x2="12" y2="13"></line>
						            <line x1="12" y1="17" x2="12.01" y2="17"></line>
						        </svg>
						        <p>${ loginErrorForDisplay }</p>
						    </div>
						</c:if>

						<div class="checkbox-group">
							<div class="checkbox-pair">
								<input type="checkbox" name="autoLogin" id="autoLogin">
								<label for="autoLogin">Auto-Login</label>
							</div>
							<div class="checkbox-pair">
								<input type="checkbox" name="RememEmail" id="RememEmail"
									<c:if test="${ rememberedEmail != null && !rememberedEmail.isEmpty() }">checked</c:if>>
								<label for="RememEmail">Remember Email</label>
							</div>
						</div>

						<button type="submit" id="loginBtn">Login</button>
					</form>
					<div class="links">
						Forget your Password? <a href="#">Reset Password</a>
					</div>
				</div>

				<!-- <div id="signupFormContainer" style="display: none;"> -->
				<div id="signupFormContainer"
					style="${formToShow eq 'signUp' ? 'display:flex;' : 'display:none;'}">
					<form action="user.do" method="post" id="signupForm">
						<%-- POST 요청 시 login/signup 구분 --%>
						<input type="hidden" name="accessType" value="signUp">

						<%-- 회원가입 에러 메시지 --%>
						<c:if test="${ signupErrorForDisplay != null && !signupErrorForDisplay.isEmpty() }">
						    <div class="form-notice form-notice-error">
						        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="notice-icon">
						            <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
						            <line x1="12" y1="9" x2="12" y2="13"></line>
						            <line x1="12" y1="17" x2="12.01" y2="17"></line>
						        </svg>
						        <p>${ signupErrorForDisplay }</p>
						    </div>
						</c:if>

						<label for="signupName" class="sr-only">이름</label> <input
							type="text" id="signupName" name="signupName" placeholder="Name"
							value="${ prevSignupName }" required> <label
							for="signupNickname" class="sr-only">닉네임</label> <input
							type="text" id="signupNickname" name="signupNickname"
							placeholder="NickName" value="${ prevSignupNickname }" required>

						<label for="signupEmail" class="sr-only">이메일</label> <input
							type="email" id="signupEmail" name="signupEmail"
							placeholder="Email" value="${ prevSignupEmail }" required>

						<label for="signupPw" class="sr-only">비밀번호</label> <input
							type="password" id="signupPw" name="signupPw"
							placeholder="Password"
							pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$"
							title="8자 이상, 영문자, 숫자, 특수문자를 모두 포함해야 합니다." required> <label
							for="confirmPw" class="sr-only">비밀번호 확인</label> <input
							type="password" id="confirmPw" name="confirmPw"
							placeholder="Confirm Password" required>
						<p id="confirmPwError" class="error-message"
							style="display: none; color: red; font-size: 0.8em;"></p>

						<label for="category" class="sr-only">관심 카테고리</label> <select
							id="category" name="category">
							<c:forEach items="${applicationScope.categoryVOList}"
								var="categoryVO">
								<option value="${ categoryVO.category_idx }">${ categoryVO.c_name }</option>
							</c:forEach>
						</select>

						<button type="submit" id="signupBtn">Sign Up</button>
					</form>
					<div class="links">
						Already have an account?<a href="#" id="switchToLoginLink">
							Login</a>
					</div>
				</div>
				<div id="resetPasswordContainer" style="display: none;">
					<form action="<%=request.getContextPath()%>/vibesync/user.do"
						method="post" id="resetPasswordForm">
						<input type="hidden" name="accessType"
							value="requestPasswordReset">

						<div class="form-notice">
							<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
								viewBox="0 0 24 24" fill="none" stroke="currentColor"
								stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
								class="notice-icon">
								<circle cx="12" cy="12" r="10"></circle>
								<line x1="12" y1="16" x2="12" y2="12"></line>
								<line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
							<p>Please enter the email address you used to sign up.</p>
						</div>

						<input type="email" name="email" placeholder="Email" required>
						<button type="submit">Get Reset Link</button>
					</form>
					<div class="links">
						<a href="#" id="switchToLoginFromReset">Back to Login</a>
					</div>
				</div>

				<!-- <div class="links switch-form-link" > -->
				<div class="links switch-form-link"
					style="${formToShow eq 'signUp' ? 'display:none;' : 'display:block;'}">
					Not a member yet?<a href="#" id="switchToSignupLink">Sign Up</a>
				</div>
			</div>

		</div>
	</div>

	<script src="./js/login.js"></script>

</body>
</html>