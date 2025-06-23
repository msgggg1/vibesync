package mvc.command.service;

import java.sql.Connection;
import java.sql.SQLException; 
import java.util.List;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;

import mvc.domain.vo.TodoVO;
import mvc.persistence.dao.TodoDAO;
import mvc.persistence.daoImpl.TodoDAOImpl;

public class TodoService {

    public List<TodoVO> getTodoListByUser(int acIdx) throws Exception {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            TodoDAO todoDAO = new TodoDAOImpl(conn);
            return todoDAO.findAllByUser(acIdx);
        } finally {
            if (conn != null) JdbcUtil.close(conn);
        }
    }
    
    public boolean updateTodoStatus(int todoIdx, boolean isCompleted) throws Exception {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false); 

            TodoDAO todoDAO = new TodoDAOImpl(conn);
            int status = isCompleted ? 1 : 0;
            int updatedRows = todoDAO.updateStatus(todoIdx, status);

            if (updatedRows > 0) {
                conn.commit(); 
                return true;
            } else {
                conn.rollback(); 
                return false;
            }
        } catch (SQLException e) {
            if (conn != null) conn.rollback(); 
            throw e; 
        } finally {
            if (conn != null) JdbcUtil.close(conn);
        }
    }

    public boolean deleteTodo(int todoIdx) throws Exception {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false); // ★ 1. 트랜잭션 시작

            TodoDAO todoDAO = new TodoDAOImpl(conn);
            int deletedRows = todoDAO.delete(todoIdx);

            if (deletedRows > 0) {
                conn.commit(); 
                return true;
            } else {
                conn.rollback();
                return false;
            }
        } catch (SQLException e) {
            if (conn != null) conn.rollback(); 
            throw e;
        } finally {
            if (conn != null) JdbcUtil.close(conn);
        }
    }
    
    public boolean addTodo(TodoVO todo) throws Exception {
        Connection conn = null;

        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false); 

            TodoDAO todoDAO = new TodoDAOImpl(conn);
            int addedRows = todoDAO.addTodo(todo);

            if (addedRows > 0) {
                conn.commit(); 
                return true;
            } else {
                conn.rollback(); 
            }
        } catch (Exception e) {
            if (conn != null) conn.rollback(); 
            throw e; // 예외를 상위로 던져서 문제 인지시키기
        } finally {
            if (conn != null) JdbcUtil.close(conn);
        }
        return false;
    }
    
    public boolean updateTodo(TodoVO todo) throws Exception {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false);
            TodoDAO todoDAO = new TodoDAOImpl(conn);
            int result = todoDAO.updateTodo(todo);
            if (result > 0) {
                conn.commit();
                return true;
            }
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) JdbcUtil.close(conn);
        }
        return false;
    }
}