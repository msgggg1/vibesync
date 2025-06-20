package mvc.command.service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.NamingException;

import com.util.ConnectionProvider;
import com.util.JdbcUtil;
import com.util.PasswordUtil;

import mvc.domain.vo.NoteVO;
import mvc.domain.vo.UserDetailVO;
import mvc.persistence.dao.NoteDAO;
import mvc.persistence.dao.SettingDAO;
import mvc.persistence.dao.UserAccountDAO;
import mvc.persistence.daoImpl.NoteDAOImpl;
import mvc.persistence.daoImpl.SettingDAOImpl;
import mvc.persistence.daoImpl.UserAccountDAOImpl;
import net.coobird.thumbnailator.Thumbnails;

public class SettingService {

   // 변경된 테마 설정값 적용
   public void setTheme (int userAcIdx, String theme) {
      Connection conn = null;
      
      try {
         conn = ConnectionProvider.getConnection();
         
         SettingDAO settingDAO = new SettingDAOImpl(conn);
         settingDAO.updateTheme(userAcIdx, theme);
         
      } catch (NamingException e) {
         e.printStackTrace();
      } catch (SQLException e) {
         e.printStackTrace();
      } finally {
         JdbcUtil.close(conn);
      }
   }

   // 기존의 테마 설정값 불러오기
   public String getTheme (int userAcIdx) {
      String theme = null;
      
      Connection conn = null;
      
      try {
         conn = ConnectionProvider.getConnection();
         
         SettingDAO settingDAO = new SettingDAOImpl(conn);
         theme = settingDAO.selectTheme(userAcIdx);
         
      } catch (NamingException e) {
         e.printStackTrace();
      } catch (SQLException e) {
         e.printStackTrace();
      } finally {
         JdbcUtil.close(conn);
      }
      
      return theme;
   }

   /**
     * 사용자의 비밀번호를 확인하고, 성공 시 사용자 정보를 반환합니다.
     * @param acIdx 확인할 사용자의 ID
     * @param inputPassword 사용자가 입력한 비밀번호
     * @return 'success' (boolean)와 'userData' (UserDetailVO)를 담은 Map
     */
    public Map<String, Object> checkUserPasswordAndGetData(int acIdx, String inputPassword) throws Exception {
        Map<String, Object> result = new HashMap<>();
        Connection conn = null;
        try {
           conn = ConnectionProvider.getConnection();
            UserAccountDAO dao = new UserAccountDAOImpl(conn);
            UserDetailVO user = dao.getUserAccountById(acIdx);

            if (user == null) {
                result.put("success", false);
                result.put("message", "사용자 정보를 찾을 수 없습니다.");
                return result;
            }

            // 입력된 비밀번호를 DB의 salt 값으로 해싱
            String hashedInputPassword = PasswordUtil.hashPassword(inputPassword, user.getSalt());

            if (hashedInputPassword.equals(user.getPw())) {
                result.put("success", true);
                // 보안을 위해 비밀번호와 salt 정보는 제거하고 반환
                user.setPw(null);
                user.setSalt(null);
                result.put("userData", user);
            } else {
                result.put("success", false);
                result.put("message", "비밀번호가 일치하지 않습니다.");
            }
        } finally {
           if (conn != null) JdbcUtil.close(conn);
        }
        return result;
    }

    /**
     * [수정됨] Base64로 인코딩된 프로필 이미지를 업데이트하는 비즈니스 로직
     * @param acIdx 사용자 ID
     * @param base64Image Base64로 인코딩된 이미지 데이터 문자열 (e.g., "data:image/png;base64,iVBOR...")
     * @param rootPath 웹 애플리케이션의 실제 루트 경로
     * @return 성공 시 DB에 저장된 새 이미지 경로, 실패 시 null
     */
    public String updateProfileImage(int acIdx, String base64Image, String rootPath) throws Exception {
        String newDbPath = null;
        String newthumbPath = null;
        Connection conn = null;
        try {
           conn = ConnectionProvider.getConnection();
            UserAccountDAO dao = new UserAccountDAOImpl(conn);
            
            UserDetailVO user = dao.getUserAccountById(acIdx);
            if (user == null) {
                throw new Exception("사용자 정보를 찾을 수 없습니다.");
            }

            // [수정] 기존 프로필 이미지 및 썸네일 파일 삭제 로직 개선
            final String userNickname = user.getNickname();
            String profileDirPathStr = rootPath + "vibesync/sources" + File.separator + "profile";
            File profileDir = new File(profileDirPathStr);

            if (profileDir.exists() && profileDir.isDirectory()) {
                // 닉네임으로 시작하는 모든 파일 (e.g., duckhammer.png, t_duckhammer.jpg)을 찾기 위한 필터
                File[] oldFiles = profileDir.listFiles(new FilenameFilter() {
                    @Override
                    public boolean accept(File dir, String name) {
                        return name.startsWith(userNickname + ".") || name.startsWith("t_" + userNickname + ".");
                    }
                });
                if (oldFiles != null) {
                    for (File file : oldFiles) {
                        file.delete();
                    }
                }
            }
            
            // 1. Base64 데이터 파싱
            String[] parts = base64Image.split(",");
            if (parts.length != 2) throw new IllegalArgumentException("잘못된 Base64 이미지 형식입니다.");
            
            String mimeType = parts[0].split(":")[1].split(";")[0];
            String extension = mimeType.substring(mimeType.indexOf('/') + 1);
            byte[] imageBytes = Base64.getDecoder().decode(parts[1]);

            // 2. 새 파일명 및 경로 설정
            String newFileName = userNickname + "." + extension;
            if (!profileDir.exists()) {
                profileDir.mkdirs();
            }
            File newFile = new File(profileDir, newFileName);
            newDbPath = "sources/profile/" + newFileName; // DB에는 원본 경로만 저장
            newthumbPath = "sources/profile/t_" + newFileName; // DB에는 원본 경로만 저장

            // 3. 원본 파일 저장
            try (FileOutputStream fos = new FileOutputStream(newFile)) {
                fos.write(imageBytes);
            }
            
            // [신규] 4. 썸네일 생성
            File thumbnailFile = new File(profileDir, "t_" + newFileName);
            Thumbnails.of(newFile)
                      .size(150, 150)
                      .toFile(thumbnailFile);
            
            // 5. DB에 새 이미지 경로 업데이트
            dao.updateProfileImagePath(acIdx, newDbPath);
        } finally {
           if (conn != null) JdbcUtil.close(conn);
        }
        return newthumbPath;
    }

    /**
     * [신규] 사용자의 비밀번호를 변경합니다.
     * @param acIdx 사용자 ID
     * @param newPassword 새로운 평문 비밀번호
     * @return 성공 시 true, 실패 시 false
     */
    public boolean alterUserPassword(int acIdx, String newPassword) throws Exception {
       Connection conn = null;
        try {
           conn = ConnectionProvider.getConnection();
            // 1. 새로운 salt 생성
            String newSalt = PasswordUtil.generateSalt();
            
            // 2. 새 비밀번호를 새 salt로 해싱
            String newHashedPassword = PasswordUtil.hashPassword(newPassword, newSalt);

            // 3. DB 업데이트
            UserAccountDAO dao = new UserAccountDAOImpl(conn);
            dao.updatePassword(acIdx, newHashedPassword, newSalt);
            
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
           if (conn != null) JdbcUtil.close(conn);
        }
    }

    public void deleteUserAccount(int acIdx, String rootPath) throws Exception {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false); // 트랜잭션 시작

            UserAccountDAO userDAO = new UserAccountDAOImpl(conn);
            NoteDAO noteDAO = new NoteDAOImpl(conn);

            // 1. 삭제할 파일 목록 가져오기
            // 1-1. 프로필 이미지 경로
            UserDetailVO user = userDAO.getUserAccountById(acIdx);
            String profileImgPath = (user != null) ? user.getImg() : null;

            // 1-2. 작성한 모든 노트의 이미지 경로들
            List<NoteVO> userNotes = noteDAO.getAllNotesByAccount(acIdx);

            // 2. DB에서 계정 삭제 (ON DELETE CASCADE로 관련 레코드 자동 삭제)
            userDAO.deleteAccount(acIdx);

            // 3. 서버에서 파일 삭제
            // 3-1. 프로필 이미지 삭제
            if (profileImgPath != null && !profileImgPath.isEmpty()) {
                deleteFile(rootPath, profileImgPath);
            }

            // 3-2. 노트 이미지들 삭제
            for (NoteVO note : userNotes) {
                // 썸네일 이미지 삭제
                if (note.getTitleImg() != null && !note.getTitleImg().isEmpty()) {
                    deleteFile(rootPath, note.getTitleImg());
                }
                // 본문 이미지들 삭제
                if (note.getImg() != null && !note.getImg().isEmpty()) {
                    String[] contentImgs = note.getImg().split("\\|");
                    for (String imgPath : contentImgs) {
                        deleteFile(rootPath, imgPath);
                    }
                }
            }

            conn.commit(); // 모든 작업 성공 시 커밋
        } catch (Exception e) {
            if (conn != null) conn.rollback(); // 오류 발생 시 롤백
            e.printStackTrace();
            throw new Exception("회원 탈퇴 처리 중 오류가 발생했습니다.", e);
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException ignored) {}
               if (conn != null) JdbcUtil.close(conn);
            }
        }
    }

    // 파일 삭제 헬퍼 메서드
    private void deleteFile(String rootPath, String relativePath) {
        if (relativePath == null || relativePath.trim().isEmpty()) return;
        try {
            File fileToDelete = new File(rootPath, relativePath.trim());
            if (fileToDelete.exists()) {
                fileToDelete.delete();
            }
        } catch (Exception e) {
            // 파일 삭제 실패 시 에러 로깅 (하지만 전체 프로세스는 계속 진행)
            System.err.println("파일 삭제 실패: " + relativePath);
            e.printStackTrace();
        }
    }
}
