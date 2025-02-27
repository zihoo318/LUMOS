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

    @Id  // 기본 키 (PK)
    private String id;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false)
    private String email;

    @Enumerated(EnumType.STRING)  // Enum 타입 저장
    @Column(nullable = false)
    private Role role;  // 역할 추가 (ROLE_USER, ROLE_ADMIN 등)
}
