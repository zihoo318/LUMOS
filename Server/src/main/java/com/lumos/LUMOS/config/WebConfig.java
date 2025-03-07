package com.lumos.LUMOS.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("http://localhost:63342", "http://localhost:8080")  // 필요한 모든 출처 허용
                .allowedMethods("GET", "POST", "PUT", "DELETE")
                .allowedHeaders("*")
                .allowCredentials(true);
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // static 경로 설정
        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/")
                .setCachePeriod(3600)  // 캐시 시간 설정
                .resourceChain(true);  // 리소스 체인 활성화

        // templates 경로 설정
        registry.addResourceHandler("/templates/**")
                .addResourceLocations("classpath:/templates/")  // templates 경로 설정
                .setCachePeriod(3600)  // 캐시 시간 설정
                .resourceChain(true);  // 리소스 체인 활성화
    }

}
