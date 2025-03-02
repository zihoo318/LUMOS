package com.lumos.LUMOS.service;

import com.lumos.LUMOS.entity.Code;
import com.lumos.LUMOS.entity.Register;
import com.lumos.LUMOS.entity.User;
import com.lumos.LUMOS.repository.RegisterRepository;
import com.lumos.LUMOS.repository.CodeRepository;
import java.util.Optional;
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
        // 먼저 입력된 code가 이미 Code 테이블에 존재하는지 확인
        Optional<Code> existingCode = codeRepository.findByCode(code);

        // 코드가 이미 존재하면 그 코드의 codeId를 가져옴
        if (existingCode.isPresent()) {
            // 이미 존재하는 코드의 codeId를 가져옴
            Code foundCode = existingCode.get();

            // Register 테이블에 저장할 정보를 준비
            Register register = new Register();
            register.setUser(user);               // 사용자 설정
            register.setCode(foundCode);          // Code 객체를 그대로 설정 (codeId 포함)
            register.setRegisterDate(LocalDate.now());  // 등록 날짜 설정

            // Register 정보 저장
            registerRepository.save(register);

            return "Code registered successfully.";
        } else {
            // 코드가 존재하지 않으면 바로 종료
            return "Code does not exist in the system.";
        }
    }

    // 별명 등록하는 함수
    public String setCodeNameForRegister(Register register, String codeName) {
        // codeName을 Register 테이블에 저장
        register.setCodeName(codeName);
        // Register 정보 업데이트
        registerRepository.save(register);

        return "Nickname saved successfully for the code.";
    }
}
