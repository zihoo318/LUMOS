package com.lumos.LUMOS.repository;

import com.lumos.LUMOS.entity.Code;
import org.springframework.data.jpa.repository.JpaRepository;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
}