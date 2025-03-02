package com.lumos.LUMOS.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;

@Entity
@Table(name = "code")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Code {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int codeId; // 코드 ID (자동 증가)

    private String code;        // 코드 내용
    private String txtName;      // 코드 텍스트 파일 이름
    private String originalName; // 원본 파일 이름
    private String summaryName;  // 요약 파일 이름
    private LocalDate createDate; // 코드 생성 날짜 (LocalDate 타입 사용)
}