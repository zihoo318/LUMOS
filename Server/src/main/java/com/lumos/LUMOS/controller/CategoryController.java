// 개인 카테고리 관련 기능
package com.lumos.LUMOS.controller;


import com.lumos.LUMOS.entity.*;
import com.lumos.LUMOS.repository.CategoriesRepository;
import com.lumos.LUMOS.repository.InCategoryRepository;
import com.lumos.LUMOS.repository.RegisterRepository;
import com.lumos.LUMOS.service.CategoryService;
import com.lumos.LUMOS.service.RegisterService;
import com.lumos.LUMOS.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/category")
public class CategoryController {

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private RegisterRepository registerRepository;
    @Autowired
    private CategoriesRepository categoriesRepository;
    @Autowired
    private InCategoryRepository inCategoryRepository;
    @Autowired
    private CategoryService categoryService;

    // 새로운 카테고리 생성
    @PostMapping("/create")
    public ResponseEntity<String> createCategory(@RequestParam String username, @RequestParam String categoryName) {
        // 사용자 객체를 username으로 찾음
        Optional<User> userOptional = userRepository.findByUsername(username);

        if (userOptional.isEmpty()) {
            return ResponseEntity.badRequest().body("유효하지 않은 사용자입니다.");
        }

        User user = userOptional.get();
        Categories category = new Categories();
        category.setUser(user);
        category.setCategoryName(categoryName);

        categoriesRepository.save(category);
        return ResponseEntity.ok("카테고리 저장 완료");
    }

    // 카테고리에 코드 연결하기
    @PostMapping("/addCodeToCategory")
    public ResponseEntity<String> addCodeToCategory(@RequestParam int categoryId, @RequestParam int registerId) {
        // 카테고리 존재 확인
        Optional<Categories> categoryOptional = categoriesRepository.findById(categoryId);
        if (categoryOptional.isEmpty()) {
            return ResponseEntity.badRequest().body("유효하지 않은 카테고리입니다.");
        }
        Categories category = categoryOptional.get();

        // 등록된 코드 찾기
        Optional<Register> registerOptional = registerRepository.findById(registerId);
        if (registerOptional.isEmpty()) {
            return ResponseEntity.badRequest().body("유효하지 않은 등록 정보입니다.");
        }
        Register register = registerOptional.get();

        // Code 객체 가져오기
        Code code = register.getCode(); // Code 객체 가져오기
        String codeName = register.getCodeName(); // Code Name 가져오기

        // InCategory 엔티티 생성 및 저장
        InCategory inCategory = new InCategory();
        inCategory.setCategory(category);
        inCategory.setCode(code); // Code 객체 설정
        inCategory.setCodeName(codeName); // 코드 이름 설정

        inCategoryRepository.save(inCategory);

        return ResponseEntity.ok("카테고리와 코드 연결 완료");
    }

    // 카테고리 별 전체 조회
    // 사용자의 카테고리별 코드 정보 조회 API
    @GetMapping("/getUserCategoryCodes")
    public ResponseEntity<Map<String, List<Map<String, String>>>> getUserCategoryCodes(@RequestParam String username) {
        // getUserCategoryCodes 메소드를 호출하여 해당 사용자의 카테고리별 코드 정보를 가져옵니다.
        Map<String, List<Map<String, String>>> categoryCodes = categoryService.getUserCategoryCodes(username);

        if (categoryCodes.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);  // 카테고리가 없으면 404 반환
        }

        return ResponseEntity.ok(categoryCodes);  // 카테고리 정보 반환
    }

}

