package com.lumos.LUMOS.controller;

import com.lumos.LUMOS.service.CodeService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin")
public class AdminController {

    private final CodeService codeService;

    public AdminController(CodeService codeService) {
        this.codeService = codeService;
    }

    // 특정 code_id를 가진 user_id에게 푸시 알림 전송
    @PostMapping("/notification")
    public ResponseEntity<String> sendNotification(@RequestParam Long codeId, @RequestBody String message) {
        int notifiedUsers = codeService.sendPushNotification(codeId, message);
        return ResponseEntity.ok("푸시 알림 전송 완료! 전송된 유저 수: " + notifiedUsers);
    }
}
