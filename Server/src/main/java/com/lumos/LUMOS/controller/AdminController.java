// 관리자 관련 기능
package com.lumos.LUMOS.controller;

import com.lumos.LUMOS.service.CodeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/api/admin")
public class AdminController {

    @Autowired
    private CodeService codeService;

    // codeId와 filetype을 받아서 파일 내용 반환
    @GetMapping("/getFileContent")
    public String getFileContent(@RequestParam int codeId, @RequestParam String filetype) {
        return codeService.getFileContent(codeId, filetype);
    }

    // 수정된 파일 내용을 받아서 파일에 덮어씌우기
    @PostMapping("/updateFileContent")
    public void updateFileContent(@RequestParam int codeId, @RequestParam String filetype, @RequestBody String content) {
        codeService.updateFileContent(codeId, filetype, content);
    }

    // 특정 code_id를 가진 user_id에게 푸시 알림 전송
    @PostMapping("/notification")
    public ResponseEntity<String> sendNotification(@RequestParam Long codeId, @RequestBody String message) {
        int notifiedUsers = codeService.sendPushNotification(codeId, message);
        return ResponseEntity.ok("푸시 알림 전송 완료! 전송된 유저 수: " + notifiedUsers);
    }

}
