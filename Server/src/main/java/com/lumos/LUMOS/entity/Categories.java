package com.lumos.LUMOS.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "categories")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Categories {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int categoryId; // 카테고리 ID (자동 증가)

    @ManyToOne
    @JoinColumn(name = "username", nullable = false)
    private User user; // 카테고리를 생성한 사용자 (다대일 관계, User 엔티티 참조)

    private String categoryName; // 카테고리 이름
}