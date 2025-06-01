package mvc.command.service;

import mvc.domain.dto.SignUpDTO;
import mvc.domain.vo.UserSessionVO;
import mvc.persistence.dao.UserDAO;

public class SignUpService {
	
    private UserDAO userAccountDAO;

    public SignUpService(UserDAO userAccountDAO) {
        this.userAccountDAO = userAccountDAO;
    }

    public UserSessionVO register(SignUpDTO dto) {
    	UserSessionVO userInfo = null;
    	
    	Boolean isEmailExists = userAccountDAO.isEmailExists(dto.getEmail());
    	Boolean isNicknameExists = userAccountDAO.isNicknameExists(dto.getNickname());
    	
    	if (isEmailExists || isNicknameExists) {
    		if (isEmailExists) throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
    		if (isNicknameExists) throw new IllegalArgumentException("이미 사용 중인 닉네임입니다.");
    	} else {
    		userInfo = userAccountDAO.insertUser(dto);
    	}
    	
    	return userInfo;
    }
}
