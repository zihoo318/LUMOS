// 코드 등록 정보를 관리하는 리포지토리
package com.lumos.LUMOS.repository;

import com.lumos.LUMOS.entity.Register;
import com.lumos.LUMOS.entity.User;
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

    // 특정 code_id를 가진 user_id 목록 조회
    @Query("SELECT r.user FROM Register r WHERE r.code = :codeId")
    List<Integer> findUserIdsByCodeId(Long codeId);

    void deleteByUser(User user);

    @Query("SELECT r FROM Register r WHERE r.user.username = :username ORDER BY r.registerDate DESC")
    List<Register> findTop5ByUsernameOrderByRegisterDateDesc(String username);
}