document.addEventListener("DOMContentLoaded", function () {
    // 🔹 현재 페이지 모드를 sessionStorage에서 가져옴
    let isPdfPage = sessionStorage.getItem("isPdfPage");
    let isAdminEditPage = sessionStorage.getItem("isAdminEditPage");

    let sidebarFile = "common/sidebar.html"; // 기본 사이드바

    // 🔹 PDF 페이지인 경우 pdf_sidebar.html 사용
    if (isPdfPage === "true") {
        sidebarFile = "common/pdf_sidebar.html";
    }

    // 🔹 선택된 사이드바를 동적으로 로드
    fetch(sidebarFile)
        .then(response => response.text())
        .then(data => {
            document.getElementById("sidebar-container").innerHTML = data;

            let logoImg = document.querySelector("#sidebar-container .header img");
            if (logoImg) {
                console.log("🔹 로고 경로 설정 시도: images/logo.png");
                logoImg.src = "images/logo.png";
            } else {
                console.log("⚠️ 로고 이미지 태그를 찾을 수 없음!");
                }


            if (isAdminEditPage === "true") {
                checkAdmin(); // 관리자 권한 확인
            }

            addEventListeners(); // 이벤트 리스너 추가
        });
});

fetch("common/pdf_sidebar.html")
    .then(response => response.text())
    .then(data => {
        document.getElementById("pdf-sidebar-container").innerHTML = data;

        // ✅ 로고 이미지 경로를 강제 설정
        let logoImg = document.querySelector("#pdf-sidebar-container .header img");
        if (logoImg) {
            logoImg.src = "/images/logo.png"; // ✅ 절대 경로 사용
            console.log("✅ 로고 이미지 경로 변경됨:", logoImg.src);
        } else {
            console.log("⚠️ 로고 이미지 태그를 찾을 수 없음!");
        }
    })
    .catch(error => console.error("⚠️ 사이드바 로드 중 오류 발생:", error));


// 📌 PDF 보기 페이지로 강제 이동하도록 수정
function viewPdf(type) {
    let selectedFile = sessionStorage.getItem("selectedFile") || "사용자설정이름"; // 기본값 설정

    console.log("📄 PDF 뷰어로 이동 시도:", selectedFile, type); // 확인용 로그

    // PDF 페이지 모드 활성화
    sessionStorage.setItem("isPdfPage", "true");
    sessionStorage.setItem("isAdminEditPage", "false");

    // **강제 이동 코드 추가!**
    let targetPage = `pdf_viewer.html?type=${type}&filename=${encodeURIComponent(selectedFile)}`;
    console.log("🌍 이동할 페이지:", targetPage); // 확인 로그
    window.location.href = targetPage;

    // 팝업 닫기
    closePdfPopup();
}


// 📌 이벤트 리스너 추가 (팝업 기능 포함)
function addEventListeners() {
    let confirmButton = document.querySelector(".confirm-button");
    let saveButton = document.querySelector("#save-button");

    if (confirmButton) {
        confirmButton.addEventListener("click", openPopup);
    }

    if (saveButton) {
        saveButton.addEventListener("click", saveFile);
    }

    // 파일 목록 클릭 이벤트 추가 (원본/요약 선택 팝업)
    document.addEventListener("click", function (event) {
        if (event.target.classList.contains("file-item")) {
            openPdfPopup(event.target.textContent);
        }
    });
}

// 📌 코드 입력 후 확인 버튼 클릭 시 실행
function submitCode() {
    let codeInput = document.getElementById("code-input");
    let code = codeInput.value.trim();

    if (!code) {
        alert("코드를 입력하세요.");
        return;
    }
    openPopup();
}

// 📌 파일 이름 입력 팝업 열기
function openPopup() {
    let popup = document.querySelector("#file-popup");
    let fileNameInput = document.querySelector("#file-name-input");

    popup.style.display = "flex";
    fileNameInput.value = ""; // 입력 필드 초기화
    fileNameInput.focus(); // 자동 포커스
}

// 📌 팝업 닫기
function closePopup() {
    document.querySelector("#file-popup").style.display = "none";
}

// 📌 파일 저장 기능 (코드값 + 파일명 저장)
function saveFile() {
    let fileNameInput = document.querySelector("#file-name-input");
    let fileName = fileNameInput.value.trim();
    let codeInput = document.getElementById("code-input");
    let code = codeInput.value.trim();

    if (!fileName) {
        alert("파일 이름을 입력하세요!");
        return;
    }

    if (!code) {
        alert("코드를 먼저 입력하세요!");
        return;
    }

    let fileList = document.querySelector("#file-list");
    let noFilesMessage = document.querySelector(".no-files");

    // 기본 "저장된 파일이 없습니다." 메시지 제거
    if (noFilesMessage) {
        fileList.removeChild(noFilesMessage);
    }

    // 새 파일 목록 아이템 생성 (입력한 코드 포함)
    let newFile = document.createElement("li");
    newFile.classList.add("file-item");
    newFile.textContent = `${code} / ${fileName}`;

    // 최신 파일이 위로 쌓이도록 `insertBefore()` 적용
    fileList.insertBefore(newFile, fileList.firstChild);

    // 🔹 코드 입력란 & 파일명 입력란 초기화 및 포커스 이동
    codeInput.value = "";
    fileNameInput.value = "";
    codeInput.focus();

    // 팝업 닫기
    closePopup();
}

// 📌 파일 선택 팝업 열기 (원본 PDF / 요약 PDF 선택)
function openPdfPopup(fileName) {
    let popup = document.querySelector("#pdf-popup");
    popup.style.display = "flex";
    popup.dataset.selectedFile = fileName; // 선택된 파일명 저장

    sessionStorage.setItem("selectedFile", fileName); // 선택한 파일명을 세션에 저장
}

// 📌 파일 선택 팝업 닫기
function closePdfPopup() {
    document.querySelector("#pdf-popup").style.display = "none";
}

// 📌 PDF 뷰어 페이지에서 PDF 표시
function loadPdfViewer() {
    let urlParams = new URLSearchParams(window.location.search);
    let pdfType = urlParams.get("type") || "original";
    let selectedFile = decodeURIComponent(sessionStorage.getItem("selectedFile") || "사용자설정이름");

    console.log("📌 현재 페이지에서 로드할 PDF:", selectedFile, pdfType); // 디버깅용

    let pdfViewer = document.getElementById("pdf-viewer");
    let pdfTitle = document.getElementById("pdf-title");

    // 🔹 PDF 파일 이름이 깨지지 않도록 `decodeURIComponent()` 사용
    pdfTitle.textContent = `${selectedFile} ${pdfType === "original" ? "원본" : "요약본"}`;
    pdfViewer.src = `pdfs/${pdfType}/${selectedFile}.pdf`;
}

// 📌 PDF 뷰어 페이지 로드 시 자동 실행
if (window.location.pathname.includes("pdf_viewer.html")) {
    document.addEventListener("DOMContentLoaded", loadPdfViewer);
}

// 📌 PDF 다운로드 함수 (PDF가 없더라도 오류 없이 기본값 유지)
function downloadPdf() {
    let pdfViewer = document.getElementById("pdf-viewer");

    // PDF 뷰어가 존재하지 않거나 src가 비어있는 경우
    if (!pdfViewer || !pdfViewer.src || pdfViewer.src.includes("about:blank")) {
        alert("다운로드할 PDF가 없습니다!");
        return;
    }

    // 현재 PDF 파일명을 sessionStorage에서 가져오기
    let selectedFile = sessionStorage.getItem("selectedFile") || "사용자설정이름";
    let urlParams = new URLSearchParams(window.location.search);
    let pdfType = urlParams.get("type") || "original";

    // PDF 파일 경로 설정 (기본 경로 포함)
    let pdfUrl = `pdfs/${pdfType}/${selectedFile}.pdf`;

    console.log("📥 다운로드할 PDF:", pdfUrl); // 확인용 로그

    // 새 창에서 PDF 열기 (실제 다운로드 유도)
    window.open(pdfUrl, "_blank");
}


// 📌 PDF 뷰어 페이지 로드 시 PDF 표시
if (window.location.pathname.includes("pdf_viewer.html")) {
    document.addEventListener("DOMContentLoaded", loadPdfViewer);
}

// 📌 관리자 여부 확인 (특정 코드 입력 시 관리자 권한 활성화)
function checkAdmin() {
    let isAdmin = true; // 실제 구현에서는 로그인 정보 활용
    if (isAdmin) {
        document.getElementById("edit-button").style.display = "block";
    }
}