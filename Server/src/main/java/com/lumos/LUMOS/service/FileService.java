package com.lumos.LUMOS.service;


import org.springframework.core.io.PathResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service
public class FileService {

    private static final String FILE_DIRECTORY = "C:/Users/KJH/LUMOS/test_db";

    // 파일을 Resource 형태로 로드 (다운로드 기능)
    public Resource loadFileAsResource(String fileName) throws IOException {
        Path filePath = Paths.get(FILE_DIRECTORY).resolve(fileName).normalize();
        if (!Files.exists(filePath)) {
            throw new IOException("파일을 찾을 수 없음: " + fileName);
        }
        return new PathResource(filePath);
    }

    //텍스트 파일 내용을 문자열로 변환
    public String loadTextFile(String fileName) throws IOException {
        Path filePath = Paths.get(FILE_DIRECTORY).resolve(fileName).normalize();

        if (!Files.exists(filePath)) {
            throw new IOException("파일을 찾을 수 없음: " + fileName);
        }

        // 파일을 한 줄씩 읽어 문자열로 변환
        return Files.readString(filePath, StandardCharsets.UTF_8);
    }
}
