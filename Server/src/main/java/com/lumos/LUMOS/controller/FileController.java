package com.lumos.LUMOS.controller;

import com.lumos.LUMOS.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@RestController
@RequestMapping("/api/files")
public class FileController {

    @Autowired
    private FileService fileService;

    // 특정 파일 다운로드 API
    @GetMapping("/download/{fileName}")
    public ResponseEntity<Resource> downloadFile(@PathVariable String fileName) throws IOException {
        Resource file = fileService.loadFileAsResource(fileName);

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + file.getFilename() + "\"")
                .body(file);
    }

    // 텍스트 파일 내용 반환 API
    @GetMapping("/text/{fileName}")
    public ResponseEntity<String> getTextFile(@PathVariable String fileName) {
        try {
            String content = fileService.loadTextFile(fileName);
            return ResponseEntity.ok()
                    .contentType(MediaType.TEXT_PLAIN)
                    .body(content);
        } catch (IOException e) {
            return ResponseEntity.badRequest().body("파일을 찾을 수 없음: " + fileName);
        }
    }
}
