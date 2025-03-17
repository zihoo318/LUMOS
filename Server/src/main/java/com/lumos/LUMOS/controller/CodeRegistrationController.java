//코드 관리 기능
package com.lumos.LUMOS.controller;

import com.lumos.LUMOS.entity.Register;
import com.lumos.LUMOS.entity.User;
import com.lumos.LUMOS.repository.CategoriesRepository;
import com.lumos.LUMOS.repository.RegisterRepository;
import com.lumos.LUMOS.service.RegisterService;
import com.lumos.LUMOS.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/codeRegistration")
public class CodeRegistrationController {

    @Autowired
    private RegisterService registerService;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private RegisterRepository registerRepository;
    @Autowired
    private CategoriesRepository categoriesRepository;

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

    // 특정 사용자의 모든 카테고리 ID와 이름 조회
    @GetMapping("/list")
    public ResponseEntity<?> getCategoriesByUsername(@RequestParam String username) {
        Optional<User> userOptional = userRepository.findByUsername(username);

        if (userOptional.isEmpty()) {
            return ResponseEntity.badRequest().body("유효하지 않은 사용자입니다.");
        }

        User user = userOptional.get();
        List<Map<String, Object>> categories = categoriesRepository.findByUser(user)
                .stream()
                .map(category -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("category_id", (Integer) category.getCategoryId()); // Integer로 명시적으로 설정
                    map.put("category_name", category.getCategoryName());
                    return map;
                })
                .collect(Collectors.toList());

        return ResponseEntity.ok(categories);
    }

    // 등록된 최신 5개 코드 반환
    @GetMapping("/recent/{username}")
    public List<Map<String, String>> getRecentRegisters(@PathVariable String username) {
        return registerService.getRecentRegisters(username);
    }

}
