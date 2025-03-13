package com.lumos.LUMOS.controller;

import com.lumos.LUMOS.entity.User;
import com.lumos.LUMOS.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.ErrorResponse;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    // 사용자 등록 API
    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody User user) {

        System.out.println("registerUser 실행!!!!!!!");
        try {
            User savedUser = userService.registerUser(user.getUsername(), user.getPassword(), user.getEmail(), String.valueOf(user.getRole()), user.getFcmToken());
            System.out.println("회원가입 완료: " + user.getUsername() + " role: " + user.getRole());
            return ResponseEntity.ok(savedUser);
        } catch (IllegalArgumentException e) {
            // 예: 이미 사용 중인 아이디일 경우, 메시지만 반환
            System.out.println("회원가입 실패 - 이미 사용 중인 아이디: " + user.getUsername());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            // 서버 오류가 발생한 경우, 메시지만 반환
            System.out.println("회원가입 실패 - 서버 오류: " + user.getUsername());
            e.printStackTrace();    //오류 상세 로그 출력
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("서버 오류가 발생했습니다.");
        }
    }


    // 로그인 API
    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@RequestBody User user) {
        try {
            User loggedInUser = userService.loginUser(user.getUsername(), user.getPassword(), user.getFcmToken());

            // 반환할 데이터 (비밀번호 제외)
            Map<String, Object> response = new HashMap<>();
            response.put("username", loggedInUser.getUsername());
            response.put("role", loggedInUser.getRole());
            response.put("email", loggedInUser.getEmail());
            response.put("fcmToken", loggedInUser.getFcmToken());

            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Collections.singletonMap("error", e.getMessage()));
        }
    }

}