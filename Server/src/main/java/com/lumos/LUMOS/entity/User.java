package com.lumos.LUMOS.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity  // JPA 엔터티 선언
@Table(name = "users")  // DB 테이블 이름 지정
@Getter
@Setter
@Builder
@NoArgsConstructor // 기본 생성자 추가
@AllArgsConstructor // 모든 필드를 포함하는 생성자 추가
public class User {

    @Id
    private String username; // 사용자가 입력한 ID

    @Getter
    @Column(nullable = false)
    private String password; // 비밀번호

    @Getter
    @Column(nullable = false, unique = true)
    private String email;    // 이메일
    //private Role role;  //역할

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
