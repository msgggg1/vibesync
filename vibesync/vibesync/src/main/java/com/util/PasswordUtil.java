package com.util;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom; // 추가
import java.util.Base64;

public class PasswordUtil {

    /**
     * 주어진 비밀번호와 Base64 인코딩된 salt를 이용해 SHA-256 해시 값을 생성합니다.
     */
    public static String hashPassword(String plainTextPassword, String base64Salt) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] saltBytes = Base64.getDecoder().decode(base64Salt);
            md.update(saltBytes);
            byte[] hashedBytes = md.digest(plainTextPassword.getBytes("UTF-8"));
            
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException | UnsupportedEncodingException e) {
            throw new RuntimeException("비밀번호 해싱 중 오류 발생", e);
        }
    }

    /**
     * [신규] 암호학적으로 안전한 16바이트 salt를 생성하고 Base64로 인코딩하여 반환합니다.
     * @return Base64로 인코딩된 salt 문자열
     */
    public static String generateSalt() {
        try {
            SecureRandom sr = SecureRandom.getInstanceStrong();
            byte[] saltBytes = new byte[16];
            sr.nextBytes(saltBytes);
            return Base64.getEncoder().encodeToString(saltBytes);
        } catch (NoSuchAlgorithmException e) {
            // 이 예외는 거의 발생하지 않으므로 런타임 예외로 처리
            throw new RuntimeException("Salt 생성 중 오류 발생", e);
        }
    }
}