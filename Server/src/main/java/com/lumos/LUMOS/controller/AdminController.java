// 관리자 관련 기능
package com.lumos.LUMOS.controller;

import com.lumos.LUMOS.service.CodeService;
import org.springframework.beans.factory.annotation.Autowired;
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

}

