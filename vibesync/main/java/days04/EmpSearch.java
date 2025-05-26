package days04;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.doit.domain.DeptVO;
import org.doit.domain.EmpVO;

import com.util.DBConn;

@WebServlet("/days04/empsearch.htm")
public class EmpSearch extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public EmpSearch() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		System.out.print("doGet...");
		
		Connection conn = null;
		   PreparedStatement pstmt = null;
		   String sql =  " SELECT * " 
				       + " FROM dept";
		   ResultSet rs = null;   
		   
		   int deptno;
		   String dname, loc;
		   
		   DeptVO dvo = null;
		   ArrayList<DeptVO> dlist = null;
		   Iterator<DeptVO> dir = null;
		   
		   try{
			   conn = DBConn.getConnection();
			   pstmt = conn.prepareStatement(sql);
			   rs = pstmt.executeQuery();
			   if( rs.next() ){
				   dlist = new ArrayList<>();
				   do{
					   
					   deptno = rs.getInt("deptno");
					   dname = rs.getString("dname");
					   loc = rs.getString("loc");
					   
					   dvo = new DeptVO().builder()
					        .deptno(deptno).dname(dname).loc(loc)
					        .build();
					   dlist.add(dvo);
				   }while( rs.next() );
			   } // if
		   }catch(Exception e){
			   e.printStackTrace();
		   }finally{
			   try{
				 pstmt.close();  
				 rs.close();  
			     //DBConn.close();
			   }catch(Exception e){
				   e.printStackTrace();
			   }
		   } // try 
		   
		   // 2. 잡 정보
		   sql =  "select distinct job from emp order by job asc"; 
		   
		   String job;
		   
		   ArrayList<String> jlist = null;
		   
		   try{
			   pstmt = conn.prepareStatement(sql);
			   rs = pstmt.executeQuery();
			   if( rs.next() ){
				   jlist = new ArrayList<>();
				   do{
					  job = rs.getString("job"); 
					  jlist.add(job);
				   }while( rs.next() );
			   } // if
		   }catch(Exception e){
			   e.printStackTrace();
		   }finally{
			   try{
				 pstmt.close();  
				 rs.close();  
			   }catch(Exception e){
				   e.printStackTrace();
			   }
		   } // try 
		   
		   // 3. 사원정보
		   // ? deptno=10&deptno=30&job=Y&job&z;
		   String pDeptno = null, pJob = null;
		   String[] pDeptnoArr = request.getParameterValues("deptno");
		   String[] pJobArr = request.getParameterValues("job");
		   
		   if (pDeptnoArr != null) pDeptno = String.join(", ", pDeptnoArr);
		   if (pJobArr != null) {
			   pJob = String.join("', '", pJobArr);
			   pJob = String.format("'%s'", pJob);
		   }
		   
		   sql = "select empno, ename, job, mgr, to_char(hiredate, 'yyyy-MM-dd') hiredate, sal,comm, deptno from emp";
				   // where deptno in (10 ,20, 30) and job in ( 'x', 'y', 'z');
		   if (pDeptno != null) {
			   sql += " where deptno in (" + pDeptno + ")";
		   }
		   if (pJob != null) {
			   sql += String.format(" %s job in (%s)", pDeptno == null ? " where" : " and", pJob);
		   }
		   sql += " order by deptno asc";
		   System.out.println("[3] sql : " + sql);
		   
		   int empno;
		   String ename;
		   int mgr;
		   Date hiredate;
		   double sal, comm;
		   
		   EmpVO evo = null;
		   ArrayList<EmpVO> elist = null;
		   try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				elist = new ArrayList<EmpVO>();
				do {
					empno = rs.getInt("empno");
		               ename = rs.getString("ename");
		               job = rs.getString("job");
		               mgr = rs.getInt("mgr");
		               hiredate = rs.getDate("hiredate");
		               sal = rs.getDouble("sal");
		               comm = rs.getDouble("comm");
		               deptno = rs.getInt("deptno");
		               evo = new EmpVO(empno, ename, job, mgr, hiredate, sal, comm, deptno);
		               elist.add(evo);
				} while (rs.next());
			}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				try {
				 pstmt.close();  
				 rs.close(); 
				 DBConn.close();
				}catch(Exception e){
					   e.printStackTrace();
			   }
			}
		
		request.setAttribute("dlist", dlist);
		request.setAttribute("jlist", jlist);
		request.setAttribute("elist", elist);

		String path = "/days04/ex06_emp_search_jstl.jsp?";
		RequestDispatcher dispatcher = request.getRequestDispatcher(path);
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

}
