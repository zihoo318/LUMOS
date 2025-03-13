package com.lumos.LUMOS.service;

import com.lumos.LUMOS.entity.Code;
import com.lumos.LUMOS.repository.CodeRepository;
import com.lumos.LUMOS.repository.RegisterRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class CodeService {

    @Autowired
    private CodeRepository codeRepository;
    @Autowired
    private RegisterRepository registerRepository;

    // 파일의 내용 반환(스트리밍 방식)
    public String getFileContent(int codeId, String filetype) {
        Optional<Code> optionalCode = codeRepository.findById(codeId);

        if (optionalCode.isPresent()) {
            Code code = optionalCode.get();
            String filePath = getFilePath(code, filetype);

            StringBuilder content = new StringBuilder(); // 파일 내용을 저장할 StringBuilder

            try (BufferedReader br = Files.newBufferedReader(Paths.get(filePath))) {
                String line;
                // 한 줄씩 파일을 읽어서 StringBuilder에 추가
                while ((line = br.readLine()) != null) {
                    content.append(line).append("\n"); // 줄바꿈도 포함
                }
            } catch (IOException e) {
                e.printStackTrace();
            }

            return content.toString(); // 전체 내용을 String으로 반환
        }

        return null;
    }

    // 수정된 파일 내용 덮어쓰기
    public void updateFileContent(int codeId, String filetype, String content) {
        // codeId에 해당하는 Code 엔티티를 찾기 위해 코드 리포지토리에서 조회
        Optional<Code> optionalCode = codeRepository.findById(codeId);

        // Code 엔티티가 존재하는 경우
        if (optionalCode.isPresent()) {
            // Code 엔티티를 가져옴
            Code code = optionalCode.get();

            // 해당 filetype에 맞는 파일 경로를 가져옴
            String filePath = getFilePath(code, filetype);

            try {
                // 수정된 content를 해당 경로의 파일에 덮어쓰기
                // Files.write는 파일에 내용을 쓰는 메소드로, content.getBytes()는 문자열을 바이트 배열로 변환
                Files.write(Paths.get(filePath), content.getBytes());
            } catch (IOException e) {
                // 파일 쓰기 중 예외가 발생하면 예외 메시지를 출력
                e.printStackTrace();
            }
        }
    }

    // filetype에 맞는 파일 경로 반환
    private String getFilePath(Code code, String filetype) {
        String baseDir = "C:/Users/KJH/LUMOS/test_db/";
        switch (filetype) {
            case "original":
                return baseDir + code.getOriginalTxt();
            case "summary":
                return baseDir + code.getSummaryTxt();
            default:
                throw new IllegalArgumentException("Invalid filetype: " + filetype);
        }
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