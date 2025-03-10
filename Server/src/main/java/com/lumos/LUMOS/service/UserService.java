package com.lumos.LUMOS.service;

import com.lumos.LUMOS.entity.Role;
import com.lumos.LUMOS.entity.User;
import com.lumos.LUMOS.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    // 평문으로 저장하는 것이 아닌 비밀번호를 암호화해서 저장
    @Autowired
    private BCryptPasswordEncoder passwordEncoder;  // 비밀번호 암호화

    // 사용자 등록 (아이디와 이메일 중복 확인)
    public User registerUser(String username, String password, String email, String role, String fcmToken) {
        // 아이디 중복 확인
        Optional<User> existingUsername = userRepository.findByUsername(username);
        if (existingUsername.isPresent()) {
            throw new IllegalArgumentException("이미 사용 중인 아이디입니다.");
        }

        // 이메일 중복 확인
        Optional<User> existingEmail = userRepository.findByEmail(email);
        if (existingEmail.isPresent()) {
            throw new IllegalArgumentException("이미 사용 중인 이메일입니다.");
        }

        // role을 대문자로 변환 후 Enum으로 변환
        Role userRole = Role.fromString(role);


        // 비밀번호 암호화
        String encodedPassword = passwordEncoder.encode(password);

        User user = User.builder()
                .username(username)
                .password(encodedPassword)
                .email(email)
                .role(userRole)  // 변환된 Role 사용
                .fcmToken(fcmToken)
                .build();

        // 저장 후 반환되는 사용자 출력
        User savedUser = userRepository.save(user);
        System.out.println("저장된 사용자: " + savedUser);  // 반환된 사용자 객체를 출력

        return savedUser; // 저장된 사용자 반환
    }

    public User loginUser(String username, String password, String fcmToken) {
        Optional<User> optionalUser = userRepository.findByUsername(username);
        User existingUser = optionalUser.orElseThrow(() -> new IllegalArgumentException("아이디가 올바르지 않습니다."));

        // 비밀번호 확인
        if (!passwordEncoder.matches(password, existingUser.getPassword())) {
            throw new IllegalArgumentException("비밀번호가 맞지 않습니다.");
        }

        // 로그인 성공 시 FCM 토큰 업데이트
        if (fcmToken != null && !fcmToken.isEmpty()) {
            existingUser.setFcmToken(fcmToken);
            userRepository.save(existingUser); // DB에 업데이트
        }

        return existingUser;
    }
}
