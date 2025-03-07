// 코드 등록 정보를 관리하는 리포지토리
package com.lumos.LUMOS.repository;

import com.lumos.LUMOS.entity.Register;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;

import java.util.List;

public interface RegisterRepository extends JpaRepository<Register, Integer> {
    @Query("SELECT r.codeName FROM Register r " +
            "JOIN r.user u " +
            "WHERE r.registerDate = :date " +
            "AND u.username = :username")
    List<String> findCodeNamesByDate(@Param("date") LocalDate date, @Param("username") String username);
}