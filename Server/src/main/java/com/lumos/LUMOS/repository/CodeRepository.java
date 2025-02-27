// 코드 정보를 관리하는 리포지토리
package com.example.demo.repository;

import com.example.demo.entity.Code;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CodeRepository extends JpaRepository<Code, Long> {
}