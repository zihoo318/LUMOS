package com.lumos.LUMOS.controller;

import com.lumos.LUMOS.service.RegisterService;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@RestController
@RequestMapping("/api/calendar")
public class CalendarController {

    private final RegisterService registerService;

    public CalendarController(RegisterService registerService) {
        this.registerService = registerService;
    }

    @GetMapping("/files")
    public List<String> getFilesByDate(@RequestParam("date") String date, @RequestParam("user") String userName) {
        // String → LocalDate 변환
        LocalDate localDate = LocalDate.parse(date, DateTimeFormatter.ISO_DATE);

        System.out.println(userName + "이 캘린더 호출!! " + localDate);

        // 서비스에서 데이터를 가져온 후 콘솔에 출력
        List<String> fileList = registerService.getFilesByDate(localDate, userName);
        System.out.println("받아온 파일 목록: " + fileList);

        return registerService.getFilesByDate(localDate, userName);
    }

}
