package com.lumos.LUMOS.service;

import com.lumos.LUMOS.entity.Categories;
import com.lumos.LUMOS.entity.InCategory;
import com.lumos.LUMOS.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CategoryService {

    private final RegisterRepository registerRepository;
    private final CodeRepository codeRepository;
    private final UserRepository userRepository;
    private final CategoriesRepository categoriesRepository;
    private final InCategoryRepository inCategoryRepository;

    public Map<String, List<Map<String, String>>> getUserCategoryCodes(String username) {
        // 해당 사용자의 카테고리 리스트를 가져옵니다.
        List<Categories> categoriesList = categoriesRepository.findByUser_Username(username);

        // 결과를 저장할 Map
        Map<String, List<Map<String, String>>> result = new HashMap<>();

        // 각 카테고리에 대해 코드와 코드 이름을 조회
        for (Categories category : categoriesList) {
            // 카테고리명
            String categoryName = category.getCategoryName();

            // 해당 카테고리에 속한 InCategory들 조회
            List<InCategory> inCategoryList = inCategoryRepository.findByCategory_User_Username(username);

            List<Map<String, String>> codeList = new ArrayList<>();

            // 각 InCategory에서 Code 정보를 가져와서 맵핑
            for (InCategory inCategory : inCategoryList) {
                if (inCategory.getCategory().equals(category)) {
                    Map<String, String> codeMap = new HashMap<>();
                    codeMap.put("codeId", String.valueOf(inCategory.getCode().getCodeId()));
                    codeMap.put("codeName", inCategory.getCodeName());
                    codeList.add(codeMap);
                }
            }

            // 카테고리명을 키로, 해당 카테고리의 코드 정보 리스트를 값으로 저장
            result.put(categoryName, codeList);
        }

        return result;
    }
}