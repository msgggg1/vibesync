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
        if (userAccountDAO.isEmailExists(dto.getEmail())) {
            throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
        }
        if (userAccountDAO.isNicknameExists(dto.getNickname())) {
            throw new IllegalArgumentException("이미 사용 중인 닉네임입니다.");
        }

        return userAccountDAO.insertUser(dto);
    }
}
