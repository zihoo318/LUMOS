document.addEventListener("DOMContentLoaded", function () {
    // 🔹 현재 페이지 모드를 sessionStorage에서 가져옴
    let sidebarContainer = document.getElementById("sidebar-container");
        if (!sidebarContainer) {
            console.error("❌ sidebar-container 요소를 찾을 수 없습니다. HTML 구조를 확인하세요.");
            return;
        }

        let sidebarFile = "common/sidebar.html"; // 기본 사이드바 경로
        let isPdfPage = sessionStorage.getItem("isPdfPage");

        if (isPdfPage === "true") {
            sidebarFile = "common/pdf_sidebar.html"; // PDF 페이지라면 PDF 사이드바 로드
        }

        fetch(sidebarFile)
            .then(response => {
                if (!response.ok) {
                    throw new Error("❌ 사이드바 파일을 불러오는 데 실패했습니다. 경로를 확인하세요.");
                }
                return response.text();
            })
            .then(data => {
                sidebarContainer.innerHTML = data;
                console.log("✅ 사이드바 로드 완료");

                // 로고 이미지 설정
                let logoImg = document.querySelector("#sidebar-container .header img");
                if (logoImg) {
                    logoImg.src = "../static/images/logo.png";
                }

                // 관리자 모드 확인
                let isAdminEditPage = sessionStorage.getItem("isAdminEditPage");
                if (isAdminEditPage === "true") {
                    checkAdmin();
                }

                // ✅ 사이드바 로드 후 버튼 이벤트 리스너 추가
                        addEventListeners();

                        // ✅ "새로운 카테고리 추가" 버튼 클릭 이벤트 리스너 추가
                        let newCategoryButton = document.querySelector(".new-category");
                        if (newCategoryButton) {
                            newCategoryButton.addEventListener("click", function () {
                                openNewCategoryPopup();
                            });
                            console.log("✅ 새로운 카테고리 추가 버튼 이벤트 리스너 정상 등록 완료");
                        } else {
                            console.error("❌ 새로운 카테고리 추가 버튼을 찾을 수 없습니다! HTML 구조를 확인하세요.");
                        }
                    })
                    .catch(error => console.error(error.message));
            });

fetch("../templates/common/pdf_sidebar.html")
    .then(response => response.text())
    .then(data => {
        document.getElementById("pdf-sidebar-container").innerHTML = data;

        // ✅ 로고 이미지 경로를 강제 설정
        let logoImg = document.querySelector("#pdf-sidebar-container .header img");
        if (logoImg) {
            logoImg.src = "../images/logo.png"; // ✅ 절대 경로 사용
            console.log("✅ 로고 이미지 경로 변경됨:", logoImg.src);
        } else {
            console.log("⚠️ 로고 이미지 태그를 찾을 수 없음!");
        }
    })
    .catch(error => console.error("⚠️ 사이드바 로드 중 오류 발생:", error));

// 📌 이벤트 리스너 추가 (팝업 기능 포함)
function addEventListeners() {
    let confirmButton = document.querySelector(".confirm-button");
    let saveButton = document.querySelector("#save-button");

    if (confirmButton) {
        confirmButton.addEventListener("click", openFileNamePopup);
    }

    if (saveButton) {
            saveButton.addEventListener("click", saveFileName);
            console.log("✅ 저장 버튼 이벤트 리스너 추가 완료");
        } else {
            console.error("❌ 저장 버튼 (#save-button) 요소를 찾을 수 없습니다!");
        }

    // 파일 목록 클릭 이벤트 추가 (원본/요약 선택 팝업)
    document.addEventListener("click", function (event) {
        if (event.target.classList.contains("file-item")) {
            openPdfPopup(event.target.textContent);
        }
    });
}

function submitCode() {
    let codeInput = document.getElementById("code-input").value.trim();
    if (!codeInput) {
        alert("코드를 입력하세요.");
        return;
    }
    sessionStorage.setItem("code", codeInput);
    console.log("✅ 저장된 코드:", sessionStorage.getItem("code")); // 디버깅 로그 추가
    openFileNamePopup();
}

function openFileNamePopup() {
    let popup = document.querySelector("#file-popup");
    if (!popup) {
        console.error("❌ 파일 이름 입력 팝업을 찾을 수 없습니다! HTML 구조를 확인하세요.");
        return;
    }

    console.log("📌 파일 이름 입력 팝업 열기");
    popup.style.display = "flex";

    let inputField = document.querySelector("#file-name-input");
    if (inputField) {
        inputField.value = "";
        inputField.focus();
    } else {
        console.error("❌ 파일 이름 입력 필드를 찾을 수 없습니다.");
    }
}

function closeFileNamePopup() {
    let popup = document.getElementById("file-popup");
    if (popup) {
        popup.style.display = "none";
        console.log("📌 파일 이름 입력 팝업 닫기");
    } else {
        console.error("❌ 파일 이름 팝업을 찾을 수 없습니다.");
    }
}

function saveFileName() {
    let fileNameInputElement = document.getElementById("file-name-input");

    if (!fileNameInputElement) {
        console.error("❌ 파일 이름 입력 필드를 찾을 수 없습니다! HTML 구조를 확인하세요.");
        return;
    }

    let fileNameInput = fileNameInputElement.value.trim();

    console.log("🛠 입력된 파일 이름:", fileNameInput); // 디버깅 로그 추가

    if (!fileNameInput) {
        alert("파일 이름을 입력하세요!");
        return;
    }

    // 📌 파일 이름 저장 (sessionStorage)
        sessionStorage.setItem("fileName", fileNameInput);
        console.log("✅ 저장된 파일 이름:", sessionStorage.getItem("fileName")); // 디버깅 로그 추가

        // 📌 기존 코드에서 `saveFile();` 호출을 제거 (즉시 파일이 추가되는 문제 방지)
        // 기존 코드 ❌
        // saveFile();

        closeFileNamePopup();
}

// 📌 파일 이름 저장 후 카테고리 선택 팝업 열기
function saveFileName() {
    let fileName = document.getElementById("file-name-input").value.trim();

    if (!fileName) {
        alert("파일 이름을 입력하세요!");
        return;
    }

    // 🔹 파일 이름을 sessionStorage에 저장
        sessionStorage.setItem("fileName", fileName);
        console.log("✅ 저장된 파일 이름:", fileName); // 디버깅 로그 추가

  // 📌 이제 카테고리 설정 팝업을 띄운다.
    // 입력 필드 초기화
    document.getElementById("file-name-input").value = "";
    openCategoryPopup();
}

function openCategoryPopup() {
    document.querySelector("#category-popup").style.display = "flex";
}

function closeCategoryPopup() {
    document.querySelector("#category-popup").style.display = "none";
}

// 📌 카테고리 선택 후 파일 저장 실행
function selectCategory(category) {
    console.log("📌 선택된 카테고리:", category); // 디버깅 로그 추가
    sessionStorage.setItem("selectedCategory", category);

    // ✅ 파일 이름 입력 팝업을 강제로 닫음
    closeFileNamePopup();

    // 📌 카테고리 선택 후 `saveFile()` 실행
    closeCategoryPopup();
    saveFile();
}

function openNewCategoryPopup() {
    document.querySelector("#new-category-popup").style.display = "flex";
}

function closeNewCategoryPopup() {
    document.querySelector("#new-category-popup").style.display = "none";
}

// 📌 새로운 카테고리 추가 후 파일 저장 실행
function saveNewCategory() {
    let categoryName = document.getElementById("new-category-input").value.trim();

    if (!categoryName) {
        alert("카테고리 이름을 입력하세요!");
        return;
    }

    // 새로운 카테고리 버튼 생성
        let newButton = document.createElement("button");
        newButton.className = "category-btn";
        newButton.textContent = categoryName;

        // ✅ 새로운 버튼 클릭 시 카테고리를 저장하고 팝업을 닫도록 이벤트 리스너 추가
        newButton.addEventListener("click", function () {
            selectCategory(categoryName);  // 카테고리 저장 함수 호출
        });

        // 기존 팝업의 카테고리 리스트에 추가
        let categoryList = document.querySelector("#category-popup .category-list");
        if (categoryList) {
            categoryList.appendChild(newButton);
        } else {
            console.error("❌ 카테고리 목록을 찾을 수 없습니다!");
        }

        // 입력 필드 초기화 및 팝업 닫기 (기존 팝업 유지)
        document.getElementById("new-category-input").value = "";
        closeNewCategoryPopup();
}

// 📌 파일 저장 함수 (카테고리 선택 후 실행됨)
function saveFile() {
    let codeInput = sessionStorage.getItem("code");
    let fileName = sessionStorage.getItem("fileName");
    let category = sessionStorage.getItem("selectedCategory");

    console.log("🔍 저장할 데이터 - 코드:", codeInput, "파일 이름:", fileName, "카테고리:", category); // 디버깅 로그 추가

    if (!codeInput) {
        alert("코드를 입력하세요!");
        return;
    }
    if (!fileName || fileName.trim() === "") {
            alert("코드 이름을 입력하세요!");
            openFileNamePopup(); // 파일 이름 팝업 다시 열기
            return;
        }
        if (!category) {
            alert("카테고리를 선택하세요!");
            openCategoryPopup(); // 카테고리 선택 팝업 다시 열기
            return;
        }

    let fileList = document.getElementById("file-list");

        if (!fileList) {
            console.error("❌ 파일 리스트 요소를 찾을 수 없습니다! HTML 구조를 확인하세요.");
            return;
        }

        let noFilesMessage = document.querySelector(".no-files");

        // 기본 "저장된 파일이 없습니다." 메시지 제거
        if (noFilesMessage) {
            fileList.removeChild(noFilesMessage);
        }

        // 새 파일 목록 아이템 생성 (카테고리 포함)
        let newFile = document.createElement("li");
        newFile.classList.add("file-item");
        newFile.textContent = `📁 ${codeInput} / ${fileName} (${category})`;

        // 최신 파일이 위로 쌓이도록 `insertBefore()` 적용
        fileList.insertBefore(newFile, fileList.firstChild);

        // 입력 필드 초기화
            document.getElementById("code-input").value = "";
            sessionStorage.removeItem("code");
            sessionStorage.removeItem("fileName");
            sessionStorage.removeItem("selectedCategory");

        console.log("✅ 파일 저장 완료! 사이드바 업데이트됨.");
}

// 📌 기존 카테고리 버튼 클릭 이벤트 리스너 추가
document.addEventListener("DOMContentLoaded", function () {
    setTimeout(() => {
        let categoryButtons = document.querySelectorAll(".category-btn");

        if (categoryButtons.length > 0) {
            categoryButtons.forEach(button => {
                button.addEventListener("click", function () {
                    let selectedCategory = this.textContent.trim();
                    selectCategory(selectedCategory);
                });
            });
            console.log("✅ 카테고리 버튼 클릭 이벤트 정상 등록 완료");
        } else {
            console.error("⚠️ 카테고리 버튼을 찾을 수 없습니다!");
        }
    }, 500);
});

document.addEventListener("DOMContentLoaded", function () {
    setTimeout(() => {
        let newCategoryButton = document.querySelector(".new-category");

        if (newCategoryButton) {
            newCategoryButton.addEventListener("click", function () {
                openNewCategoryPopup();
            });
            console.log("✅ 새로운 카테고리 추가 버튼 이벤트 리스너 정상 등록 완료");
        } else {
            console.error("❌ 새로운 카테고리 추가 버튼을 찾을 수 없습니다! HTML 구조를 확인하세요.");
        }
    }, 1000);  // 1초 후 실행
});


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

function downloadPdf() {
    document.getElementById("category-popup").style.display = "flex";
}

function closeCategoryPopup() {
    document.getElementById("category-popup").style.display = "none";
}

document.addEventListener("DOMContentLoaded", function () {
    setTimeout(() => {
        let closeButton = document.querySelector("#category-popup .close-btn");

        if (closeButton) {
            closeButton.style.display = "block";
            console.log("✅ X 버튼이 정상적으로 존재합니다!");
        } else {
            console.error("⚠️ X 버튼을 찾을 수 없습니다! HTML 구조를 확인하세요.");
        }
    }, 500);

    let newCategoryButton = document.querySelector(".new-category");

        if (newCategoryButton) {
                newCategoryButton.addEventListener("click", function () {
                    document.getElementById("new-category-popup").style.display = "flex";
                    document.getElementById("new-category-popup").style.zIndex = "1001"; // 기존 팝업보다 위로 설정
                });
            }
});

// ✅ 새로운 카테고리 팝업 닫기 함수 (기존 팝업 유지)
function closeNewCategoryPopup() {
    document.getElementById("new-category-popup").style.display = "none";
}

// ✅ 새로운 카테고리를 기존 팝업에 추가하는 함수
function saveNewCategory() {
    let categoryName = document.getElementById("new-category-input").value.trim();

    if (!categoryName) {
        alert("카테고리 이름을 입력하세요!");
        return;
    }

    // 새로운 카테고리 버튼 생성
    let newButton = document.createElement("button");
    newButton.className = "category-btn";
    newButton.textContent = categoryName;

    // ✅ 새 카테고리를 선택하면 저장되도록 이벤트 리스너 추가
        newButton.addEventListener("click", function () {
            selectCategory(categoryName);
        });

    // 기존 팝업의 카테고리 리스트에 추가
        let categoryList = document.querySelector("#category-popup .category-list");
        if (categoryList) {
            categoryList.appendChild(newButton);
        } else {
            console.error("❌ 카테고리 목록을 찾을 수 없습니다!");
        }

        // 입력 필드 초기화 및 팝업 닫기 (기존 팝업 유지)
        document.getElementById("new-category-input").value = "";
        closeNewCategoryPopup();
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