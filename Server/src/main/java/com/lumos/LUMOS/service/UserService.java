package com.lumos.LUMOS.service;

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

    //평문으로 저장하는 것이 아닌 비밀번호를 암호화해서 저장
    @Autowired
    private BCryptPasswordEncoder passwordEncoder;  // 비밀번호 암호화



    public User registerUser(String username, String password, String email) {
        //비밀번호 암호화
        String encodedPassword = passwordEncoder.encode(password);
        User user = User.builder()
                .username(username)
                .password(encodedPassword)
                .email(email)
                .build();
        return userRepository.save(user); // 저장 후 반환
    }

    public User loginUser(User user) {
        System.out.println("로그인 시도 아이디: " + user.getUsername()); // username 출력
        System.out.println("로그인 시도 비밀번호: " + user.getPassword()); // username 출력


        // 아이디 확인 (Optional 처리)
        Optional<User> optionalUser = userRepository.findByUsername(user.getUsername());

        // 로그 추가
        System.out.println("아이디 조회 결과: " + optionalUser);

        // 아이디가 존재하지 않으면 예외 던짐
        User existingUser = optionalUser.orElseThrow(() -> new IllegalArgumentException("아이디가 올바르지 않습니다."));

        // 비밀번호 확인 (암호화된 비밀번호 비교)
        if (!passwordEncoder.matches(user.getPassword(), existingUser.getPassword())) {
            throw new IllegalArgumentException("비밀번호가 맞지 않습니다.");
        }

        return existingUser;
    }
}
