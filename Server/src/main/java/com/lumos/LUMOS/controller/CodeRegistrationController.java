//코드 관리 기능
package com.lumos.LUMOS.controller;

import com.lumos.LUMOS.entity.Register;
import com.lumos.LUMOS.entity.User;
import com.lumos.LUMOS.repository.RegisterRepository;
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
    @Autowired
    private RegisterRepository registerRepository;

    // 코드 등록
    @PostMapping("/registerCode")
    public ResponseEntity<String> registerCode(@RequestParam String username, @RequestParam String code) {
        // 사용자 객체를 username으로 찾음
        Optional<User> userOptional = userRepository.findByUsername(username);

        if (userOptional.isPresent()) {
            User user = userOptional.get();
            // 코드 등록 서비스 호출
            Register register = registerService.registerCode(user, code);
            // registerId를 포함한 응답 반환
            return ResponseEntity.ok("Register ID: " + register.getRegisterId());
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found.");
        }
    }

    // 별명 저장 API
    @PostMapping("/setCodeName")
    public ResponseEntity<String> setCodeName(@RequestParam int registerId, @RequestParam String codeName) {
        // registerId로 Register 엔티티를 찾음
        Optional<Register> registerOptional = registerRepository.findById(registerId);

        if (registerOptional.isPresent()) {
            Register register = registerOptional.get();
            // 별명 설정 서비스 호출
            String result = registerService.setCodeNameForRegister(register, codeName);
            return ResponseEntity.ok(result);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Register not found.");
        }
    }

}
