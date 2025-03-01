//코드 관리 기능

@RestController
@RequestMapping("/api")
public class CodeRegistrationController {

    @Autowired
    private RegisterService RegisterService;

    // 코드 등록
    @PostMapping("/registerCode")
    public ResponseEntity<String> registerCode(@RequestParam String username, @RequestParam String code) {
        // 사용자 객체를 username으로 찾음
        Optional<User> userOptional = userRepository.findByUsername(username);

        if (userOptional.isPresent()) {
            User user = userOptional.get();
            // 코드 등록 서비스 호출
            String result = RegisterService.registerCode(user, code);
            return ResponseEntity.ok(result);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found.");
        }
    }



}
