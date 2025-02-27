package com.example.demo.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "categories")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long categoryId; // 카테고리 ID (자동 증가)

    @ManyToOne
    @JoinColumn(name = "id", nullable = false)
    private User user; // 카테고리를 생성한 사용자 (다대일 관계, User 엔티티 참조)

    private String categoryName; // 카테고리 이름
}