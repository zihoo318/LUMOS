package com.lumos.LUMOS.service;

import org.springframework.core.io.PathResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.file.*;
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
}
