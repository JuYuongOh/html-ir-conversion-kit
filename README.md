# HTML IR 변환 패키지 — 최신본 배포

회사의 IR·회사소개 자료(PPTX/PDF)를 발표용 HTML로 바꾸는 작업에 쓰는 세 파일의 **항상 최신 버전**을 받는 곳입니다.

| 파일 | 내용 |
|---|---|
| `HTML IR 변환 지침.md` | Claude 프로젝트 지침(AGENTS.md)에 넣는 규칙과 진행 순서 |
| `HTML IR 변환 사용설명서.html` | 사용 방법 안내 |
| `HTML IR 변환 패키지.zip` | 작업 폴더(docs·kit·tools) 패키지 |

## 최신본 받기

**▶ [세 파일 한 번에 받기 (HTML_IR_kit.zip)](https://github.com/JuYuongOh/html-ir-conversion-kit/releases/latest/download/HTML_IR_kit.zip)**

- 위 링크는 바뀌지 않습니다. 언제 누르든 가장 최근에 배포된 파일이 받아집니다.
- 압축을 풀면 위 세 파일이 원래 이름 그대로 들어 있습니다.
- 한 파일만 필요하면 이 페이지 위쪽 파일 목록에서 파일을 누른 뒤, 오른쪽 위의 다운로드 버튼(Download raw file)을 누르세요.
- 버전별 변경 내용과 이전 버전은 [Releases](https://github.com/JuYuongOh/html-ir-conversion-kit/releases)에서 볼 수 있습니다.

## 배포하는 방법 (관리자용)

1. 이 폴더의 세 파일을 새 버전으로 덮어씁니다. 파일 이름은 바꾸지 않습니다.
2. Claude Code에서 "배포해줘"라고 하거나, 이 폴더에서 아래 명령을 실행합니다.

```powershell
powershell -ExecutionPolicy Bypass -File .\deploy.ps1 -Message "바뀐 내용 한 줄"
```

스크립트가 커밋·푸시를 하고, 새 버전(vYYYY.MM.DD) Release에 세 파일을 묶은 `HTML_IR_kit.zip`을 올립니다.
