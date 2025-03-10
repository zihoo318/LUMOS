// 코드 정보를 관리하는 리포지토리
package com.lumos.LUMOS.repository;

import com.lumos.LUMOS.entity.Code;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CodeRepository extends JpaRepository<Code, Integer> {
    Optional<Code> findByCode(String code);
}
