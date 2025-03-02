//코드 관리 기능
package com.lumos.LUMOS.controller;

import com.lumos.LUMOS.entity.User;
import com.lumos.LUMOS.service.RegisterService;
import com.lumos.LUMOS.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Optional;

@RestController
@RequestMapping("/api")
public class CodeRegistrationController {

    @Autowired
    private RegisterService registerService;
    @Autowired
    private UserRepository userRepository;

    // 코드 등록
    @PostMapping("/registerCode")
    public ResponseEntity<String> registerCode(@RequestParam String username, @RequestParam String code) {
        // 사용자 객체를 username으로 찾음
        Optional<User> userOptional = userRepository.findByUsername(username);

        if (userOptional.isPresent()) {
            User user = userOptional.get();
            // 코드 등록 서비스 호출
            String result = registerService.registerCode(user, code);
            return ResponseEntity.ok(result);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found.");
        }
    }



}
