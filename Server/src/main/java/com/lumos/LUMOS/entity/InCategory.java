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
    private int inCategoryId; // 관계 ID (자동 증가)

    @ManyToOne
    @JoinColumn(name = "categoryId", nullable = false)
    private Categories category; // 카테고리 ID (다대일 관계)

    @ManyToOne
    @JoinColumn(name = "codeId", nullable = false)
    private Code code; // 코드 ID (다대일 관계, Code 엔티티 참조)

    private String codeName; // 코드 이름

}