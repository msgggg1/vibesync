package com.filter;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import javax.servlet.DispatcherType;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter(		dispatcherTypes = {DispatcherType.REQUEST}
					,
				urlPatterns = { 
						"*.do" 
				})
public class LoginCheckFilter extends HttpFilter implements Filter {
       
    public LoginCheckFilter() {
        super();
    }

	public void destroy() {
		System.out.println(">LoginCheckFilter destroy()");
	}

	public void doFilter(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
	        throws IOException, ServletException {
		System.out.println(">LoginCheckFilter doFilter()");
		
		String requestURI = request.getRequestURI();
		
		
		// 현재 요청이 로그인 페이지로 향하는지 확인하고, returnUrl 파라미터가 있는지 검사합니다.
	    if (requestURI.endsWith("/user.do")) {
	        String returnUrl = request.getParameter("returnUrl");
	        if (returnUrl != null && !returnUrl.isEmpty()) {
	            // returnUrl을 세션에 저장해야 하므로, 세션이 없다면 새로 생성합니다.
	            HttpSession session = request.getSession(); 
	            session.setAttribute("referer", returnUrl);
	            System.out.println("[LoginCheckFilter] returnUrl 파라미터를 세션에 저장: " + returnUrl);
	        }
	    }
	    
		
		// 1. 공개적으로 접근 가능한 '허용된 경로(Whitelist)' 목록 정의
	    List<String> publicPaths = Arrays.asList("/user.do", "/postView.do", "/comment.do", "/sidebar.do");
	    
	    boolean isPublicPath = false;
	    for (String path : publicPaths) {
	        if (requestURI.endsWith(path)) {
	            isPublicPath = true;
	            break;
	        }
	    }
	    
	    // 리소스 파일(css, js, 이미지 등)은 항상 허용
	    //웹 페이지를 올바르게 표시하는 데 필요한 정적 파일(CSS, JavaScript, 이미지, 폰트 등)에 대해서는 로그인 여부와 상관없이 항상 접근을 허용
	    if (requestURI.startsWith(request.getContextPath() + "/resources/")) {
	        isPublicPath = true;
	    }
	    
	    if (isPublicPath) {
	        chain.doFilter(request, response);
	        return; 
	    }
		
		HttpSession session = request.getSession(false);
		boolean isLoggedIn = (session != null && session.getAttribute("userInfo") != null);

		 if (isLoggedIn) {
		        chain.doFilter(request, response);
		        return;
		    }
		 
		 System.out.println("[LoginCheckFilter] 접근 거부! 로그인 페이지로 리다이렉트합니다. 요청 URI: " + requestURI);
		 
		 HttpSession newSession = request.getSession(); 
		 newSession.setAttribute("referer", requestURI);
		    
		 // 로그인 페이지로 리다이렉트
		 String loginPage = request.getContextPath() + "/vibesync/user.do";
		 response.sendRedirect(loginPage);
	}

	public void init(FilterConfig fConfig) throws ServletException {
		System.out.println(">LoginCheckFilter init()");
	}

}
