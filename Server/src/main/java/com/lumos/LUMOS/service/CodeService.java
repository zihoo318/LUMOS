package com.lumos.LUMOS.service;

import com.lumos.LUMOS.repository.RegisterRepository;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class CodeService {

    private final RegisterRepository registerRepository;

    public CodeService(RegisterRepository registerRepository) {
        this.registerRepository = registerRepository;
    }

    // 특정 code_id를 가진 user_id 목록을 찾아 푸시 알림 전송
    public int sendPushNotification(Long codeId, String message) {
        // 1. 특정 code_id를 가진 user_id 찾기
        List<Integer> userIds = registerRepository.findUserIdsByCodeId(codeId);

        if (userIds.isEmpty()) {
            System.out.println("해당 code_id(" + codeId + ")를 가진 유저 없음");
            return 0;
        }

        // 2. user_id → userCode 변환 (예: "USER_1", "USER_2")
        List<String> userCodes = userIds.stream()
                .map(id -> "USER_" + id)
                .collect(Collectors.toList());

        // 3. 푸시 알림 전송 (여기서 Firebase, AWS SNS 등을 연동 가능)
        for (String userCode : userCodes) {
            System.out.println("푸시 알림 전송: " + userCode + " → " + message);
        }

        return userCodes.size();
    }
}
