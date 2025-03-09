// 카테고리 정보를 관리하는 리포지토리
package com.lumos.LUMOS.repository;

import com.lumos.LUMOS.entity.Categories;
import com.lumos.LUMOS.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CategoriesRepository extends JpaRepository<Categories, Integer> {
    List<Categories> findByUser(User user); // 특정 사용자의 카테고리 목록 조회
    List<Categories> findByUser_Username(String username);
}