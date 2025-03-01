package com.lumos.LUMOS.service;

import com.lumos.LUMOS.entity.Code;
import com.lumos.LUMOS.entity.Register;
import com.lumos.LUMOS.entity.User;
import com.lumos.LUMOS.repository.RegisterRepository;
import com.lumos.LUMOS.repository.CodeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class RegisterService {

    private final RegisterRepository registerRepository;
    private final CodeRepository codeRepository;

    // 사용자가 코드를 등록하는 서비스
    public String registerCode(User user, String code) {

    }
}
