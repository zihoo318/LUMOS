package com.lumos.LUMOS.controller;

import com.lumos.LUMOS.entity.User;
import com.lumos.LUMOS.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*")
public class UserController {

    @Autowired
    private UserService userService;

    // 사용자 등록 API
    @PostMapping("/register")
    public ResponseEntity<User> registerUser(@RequestBody User user) {
        User savedUser = userService.registerUser(user.getUsername(), user.getPassword(), user.getEmail());
        return ResponseEntity.ok(savedUser);
    }


    // 로그인 API
    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@RequestBody User user) {
        try {
            // 로그인 시, 비밀번호를 BCrypt로 암호화하여 비교
            User loggedInUser = userService.loginUser(user);
            return ResponseEntity.ok(loggedInUser); // 로그인 성공 시 유저 정보 반환
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage()); // 오류 메시지 반환
        }
    }
}