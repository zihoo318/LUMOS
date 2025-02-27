package com.lumos.LUMOS.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "in_categories")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class InCategory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idex; // 관계 ID (자동 증가)

    @ManyToOne
    @JoinColumn(name = "category_id", nullable = false)
    private Categories category; // 카테고리 ID (다대일 관계)

    @ManyToOne
    @JoinColumn(name = "code_id", nullable = false)
    private Code code; // 코드 ID (다대일 관계, Code 엔티티 참조)

    private int fileType; // 파일 타입 (1: 텍스트, 2: 원본 PDF, 3: 요약 PDF)
}
