package com.lumos.LUMOS.repository;

import com.lumos.LUMOS.entity.InCategory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface InCategoryRepository extends JpaRepository<InCategory, Integer> {
    List<InCategory> findByCategory_User_Username(String username);
}
