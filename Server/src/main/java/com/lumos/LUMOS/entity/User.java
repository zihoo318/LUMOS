package com.lumos.LUMOS.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity  // JPA 엔터티 선언
@Table(name = "users")  // DB 테이블 이름 지정
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    @Id
    private String username; // 사용자가 입력한 ID

    @Getter
    @Column(nullable = false)
    private String password; // 비밀번호

    @Getter
    @Column(nullable = false, unique = true)
    private String email;    // 이메일

    @Enumerated(EnumType.STRING)  // 대문자로 저장되도록 지정
    @Column(nullable = false)
    private Role role;

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    // role 값을 가져올 때 자동으로 대문자로 변환
    public String getRole() {
        return role != null ? role.name().toUpperCase() : null;
    }

    public void setRole(String role) {
        this.role = Role.fromString(role);
    }
}
