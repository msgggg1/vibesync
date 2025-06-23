package mvc.command.service;

import com.sendgrid.*;
import com.sendgrid.helpers.mail.Mail;
import com.sendgrid.helpers.mail.objects.Content;
import com.sendgrid.helpers.mail.objects.Email;
import java.io.IOException;

public class EmailService {

    /**
     * 비밀번호 재설정 이메일을 발송하는 static 메서드
     * @param toEmail 받는 사람 이메일
     * @param resetLink 포함될 재설정 링크
     * @throws IOException
     */
    public static void sendPasswordResetEmail(String toEmail, String resetLink) throws IOException {
        
        // 1. 보내는 사람의 이메일 주소 (SendGrid에서 인증된 주소여야 함)
        Email from = new Email("msggms1@gmail.com", "VibeSync"); 
        
        // 2. 받는 사람의 이메일 주소
        Email to = new Email(toEmail);

        // 3. 이메일 제목
        String subject = "[VibeSync] Password Reset Request";

        // 4. 이메일 내용 (HTML 형식)
        Content content = new Content("text/html", createEmailBody(resetLink));

        // 5. SendGrid Mail 객체 생성
        Mail mail = new Mail(from, subject, to, content);

        // 6. SendGrid 객체 생성 및 API 키 설정
        // 🚨 중요: 시스템 환경변수에 SENDGRID_API_KEY가 설정되어 있어야 합니다.
        SendGrid sg = new SendGrid(System.getenv("SENDGRID_API_KEY")); 
        Request request = new Request();

        try {
            request.setMethod(Method.POST);
            request.setEndpoint("mail/send");
            request.setBody(mail.build());

            // 7. API 요청 및 응답 출력 (디버깅용)
            Response response = sg.api(request);
            System.out.println("SendGrid 응답 코드: " + response.getStatusCode());
            
        } catch (IOException ex) {
            System.err.println("SendGrid 이메일 발송 중 오류 발생");
            throw ex;
        }
    }

    // 이메일 본문 HTML을 생성하는 private 헬퍼 메서드
    private static String createEmailBody(String link) {
        return "<html><body>" +
               "<h2>VibeSync Password Reset</h2>" +
               "<p>To reset your password, please click the button below.</p>" +
               "<a href='" + link + "' style='background-color:#5DAED7; color:white; padding:14px 25px; text-align:center; text-decoration:none; display:inline-block; border-radius:4px;'>Reset Password</a>" +
               "<p>This link is valid for 1 hour.</p>" +
               "<p>If you did not request a password reset, please ignore this email.</p>" +
               "</body></html>";
    }
}