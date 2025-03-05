// 개인 카테고리 관련 기능
package com.lumos.LUMOS.controller;


import com.lumos.LUMOS.entity.Categories;
import com.lumos.LUMOS.entity.Register;
import com.lumos.LUMOS.entity.User;
import com.lumos.LUMOS.repository.CategoriesRepository;
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
@RequestMapping("/api/category")
public class CategoryController {

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private RegisterRepository registerRepository;
    @Autowired
    private CategoriesRepository categoriesRepository;

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

}

