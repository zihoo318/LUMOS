package com.lumos.LUMOS.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class webController {

    @GetMapping("/")
    public String intro() {
        return "intro";  // "Home.html" 파일을 찾아서 실행
    }

    @GetMapping("/Home")
    public String home() {
        return "Home";  // "Home.html" 파일을 찾아서 실행
    }

    @GetMapping("/category")
    public String category() {
        return "category";  // "Home.html" 파일을 찾아서 실행
    }

    @GetMapping("/date")
    public String date() {
        return "date";  // "Home.html" 파일을 찾아서 실행
    }

    @GetMapping("/SignUp")
    public String SignUp() {
        return "SignUp";  // "Home.html" 파일을 찾아서 실행
    }

    @GetMapping("/SignIn")
    public String SignIn() {
        return "SignIn";  // "Home.html" 파일을 찾아서 실행
    }

    @GetMapping("/Admin_Edit")
    public String Admin_Edit() {
        return "Admin_Edit";  // "Home.html" 파일을 찾아서 실행
    }

    @GetMapping("/SignInStart")
    public String SignInStart() {
        return "SignInStart";  // "Home.html" 파일을 찾아서 실행
    }
}
