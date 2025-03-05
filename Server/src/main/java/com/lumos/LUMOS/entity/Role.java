package com.lumos.LUMOS.entity;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

public enum Role {
    ADMIN, USER;

    @JsonCreator
    public static Role fromString(String role) {
        if (role == null || role.isEmpty()) {
            throw new IllegalArgumentException("Role cannot be null or empty");
        }
        return Role.valueOf(role.trim().toUpperCase());  // 소문자로 들어와도 변환
    }

    @JsonValue
    public String toValue() {
        return this.name();  // 항상 대문자로 변환
    }
}
