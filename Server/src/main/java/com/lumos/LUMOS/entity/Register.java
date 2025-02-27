package com.example.demo.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;

@Entity
@Table(name = "register")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Register {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int index; // 자동 증가 기본 키

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user; // 등록한 사용자 (다대일 관계, User 엔티티 참조)

    @ManyToOne
    @JoinColumn(name = "code_id", nullable = false)
    private Code code; // 등록된 코드 (다대일 관계, Code 엔티티 참조)

    private String codeName; // 코드 이름
    private LocalDate registerDate;  // 등록 날짜 (LocalDate 타입 사용)
}