// 카테고리 정보를 관리하는 리포지토리
package com.lumos.LUMOS.repository;

import com.lumos.LUMOS.entity.Categories;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CategoriesRepository extends JpaRepository<Categories, Integer> {
}