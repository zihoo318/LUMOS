package com.lumos.LUMOS.repository;

import com.lumos.LUMOS.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);

    // 사용자 이름으로 검색
    Optional<User> findByUsername(String username);
}
