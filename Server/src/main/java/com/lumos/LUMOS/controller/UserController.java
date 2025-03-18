package com.lumos.LUMOS.controller;

import com.lumos.LUMOS.entity.User;
import com.lumos.LUMOS.repository.CategoriesRepository;
import com.lumos.LUMOS.repository.InCategoryRepository;
import com.lumos.LUMOS.repository.RegisterRepository;
import com.lumos.LUMOS.repository.UserRepository;
import com.lumos.LUMOS.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.ErrorResponse;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;
    private UserRepository userRepository;
    private RegisterRepository registerRepository;
    private InCategoryRepository inCategoryRepository;
    private CategoriesRepository categoriesRepository;

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

    @DeleteMapping("/delete")
    public ResponseEntity<String> deleteUser(@RequestParam String username) {
        // 1. username을 가진 사용자 찾기
        Optional<User> userOptional = userRepository.findById(username);

        if (userOptional.isEmpty()) {
            return ResponseEntity.status(404).body("User not found");
        }

        User user = userOptional.get();

        // 2. Categories 삭제 (User -> Categories)
        categoriesRepository.deleteByUser(user);

        // 3. InCategory 삭제 (Categories -> InCategory)
        inCategoryRepository.deleteByCategoryUser(user);

        // 4. Register 삭제 (User -> Register)
        registerRepository.deleteByUser(user);

        // 5. 최종적으로 User 삭제
        userRepository.delete(user);

        return ResponseEntity.ok("User deleted successfully");
    }

}