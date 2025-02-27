// 코드 등록 정보를 관리하는 리포지토리
package com.example.demo.repository;

import com.example.demo.entity.Register;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RegisterRepository extends JpaRepository<Register, Integer> {
}