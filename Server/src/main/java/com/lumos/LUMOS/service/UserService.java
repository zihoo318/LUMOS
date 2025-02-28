package com.lumos.LUMOS.service;

import com.lumos.LUMOS.model.User;
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

    public User registerUser(User user) {
        // 비밀번호 암호화 후 저장
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        return userRepository.save(user);
    }

    public User loginUser(User user) {
        Optional<User> existingUser = userRepository.findByEmail(user.getEmail());

        return existingUser.filter(u -> passwordEncoder.matches(user.getPassword(), u.getPassword()))
                .orElseThrow(() -> new RuntimeException("Invalid email or password"));
    }

}
