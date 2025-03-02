package com.lumos.LUMOS.repository;

import com.lumos.LUMOS.entity.Code;
import com.lumos.LUMOS.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
}