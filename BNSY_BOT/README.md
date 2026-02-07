# BNSY_BOT 프로젝트

BNK SYSTEM 통합구매시스템의 자료를 학습한 LLM 기반 QnA 챗봇 서비스

## 📋 프로젝트 개요

- **서비스명**: BNSY 봇 (BNSY Bot)
- **목적**: BNK SYSTEM 통합구매시스템 관련 질의응답을 AI 챗봇으로 제공
- **타겟 사용자**: 입사 1년 차 미만 행원, 일반인
- **기술 스택**: Java 17, Spring Boot 3.2.1, JSP, MyBatis, Oracle 21c, Ollama (Llama 3)

## 🚀 빠른 시작 (Quick Start)

### 1. 사전 요구사항

- **JDK**: Java 17 이상
- **Maven**: 3.6 이상
- **Oracle Database**: 21c (테스트 모드에서는 localhost:1521)
- **Ollama**: Llama 3 모델 설치 필요

### 2. 데이터베이스 설정

#### (1) Oracle 접속 정보 수정

`src/main/resources/application.properties` 파일을 열고 데이터베이스 접속 정보를 수정하세요:

```properties
# Oracle Database Configuration
spring.datasource.url=jdbc:oracle:thin:@localhost:1521/XE
spring.datasource.username=YOUR_USERNAME
spring.datasource.password=YOUR_PASSWORD
```

> **실제 배포 시**: `@192.168.55.52:1521` 로 변경

#### (2) 필수 테이블 생성

프로젝트 루트의 `기획자료/1단계기획서.md`의 "7. DB 테이블 명세" 섹션을 참고하여 아래 테이블을 생성하세요:

- `MEMBERS` (회원 정보)
- `FILE_SOURCE`, `FILE_CHUNKS` (RAG 참조 리소스)
- `CHAT_HISTORY` (채팅 내역)
- `SERVER_METRIC` (서버 리소스 로깅)

### 3. 애플리케이션 실행

#### Maven을 이용한 실행

```bash
cd BNSY_BOT
mvn clean install
mvn spring-boot:run
```

#### IDE에서 실행

`src/main/java/com/bnsy/bot/BnsyBotApplication.java` 파일을 실행하세요.

### 4. 접속 확인

브라우저에서 아래 주소로 접속:

```
http://localhost:9595
```

## 📦 프로젝트 구조

```
BNSY_BOT/
├── src/
│   ├── main/
│   │   ├── java/com/bnsy/bot/
│   │   │   ├── config/          # 설정 클래스 (MyBatis, 보안 등)
│   │   │   ├── controller/      # 컨트롤러 (MVC)
│   │   │   ├── service/          # 서비스 인터페이스
│   │   │   ├── service/impl/    # 서비스 구현체
│   │   │   ├── mapper/           # MyBatis Mapper 인터페이스
│   │   │   ├── dto/              # 데이터 전송 객체
│   │   │   ├── exception/        # 예외 처리 클래스
│   │   │   └── BnsyBotApplication.java  # 메인 클래스
│   │   ├── resources/
│   │   │   ├── mappers/          # MyBatis XML 매퍼
│   │   │   └── application.properties
│   │   └── webapp/
│   │       └── WEB-INF/views/    # JSP 파일
│   └── test/java/                # 테스트 코드
└── pom.xml
```

## ⚙️ 주요 설정

### 서버 포트

- **포트**: 9595
- 외부 접속: `39.113.16.163:9595` (포트포워딩 설정 필요)

### JSP 뷰 설정

- **JSP 경로**: `/WEB-INF/views/`
- **확장자**: `.jsp`

### MyBatis 설정

- **Mapper XML 위치**: `classpath:mappers/**/*.xml`
- **DTO 패키지**: `com.bnsy.bot.dto`
- **카멜케이스 변환**: 활성화 (DB: `USER_NAME` → Java: `userName`)

### RAG 파일 경로

- **청크 데이터**: `C:\Users\밍\Desktop\workspace\BNSY_Q&A\RAG_CHUNKED`
- **원본 소스**: `C:\Users\밍\Desktop\workspace\BNSY_Q&A\RAG_SOURCE`

## 🏗️ 개발 가이드라인

### SOLID 원칙 준수

- 모든 서비스는 **Interface**를 정의하고 구현합니다.
- 특히 RAG 관련 서비스는 향후 다른 LLM 모델로 교체 가능하도록 설계되어야 합니다.

### 주석 작성 규칙

- 모든 클래스와 핵심 메서드에 **Javadoc** 작성 필수
- **자연스러운 한국어**로 로직의 의도와 흐름 설명
- 단순 코드 번역 금지

**예시**:
```java
/**
 * 사용자 질문을 벡터화하여 DB 내 유사도 상위 3개 문서를 추출합니다.
 * 
 * @param question 사용자 질문 텍스트
 * @return 유사도 상위 3개 문서 리스트
 */
public List<FileChunk> searchSimilarDocuments(String question) {
    // 구현...
}
```

### 예외 처리

- `@RestControllerAdvice`를 사용한 전역 예외 처리 구현 예정
- 실패한 쿼리와 통신은 콘솔에 원인과 IP 주소 출력

## 📚 API 명세

> TBD (추후 업데이트)

## 🔍 참고 자료

- **기획서**: `기획자료/1단계기획서.md`
- **디자인**: `기획자료/BNSY_BOT_1단계(테스트버전).pdf`
- **이미지 리소스**: `images/` 폴더

## 📝 라이선스

포트폴리오 프로젝트

## 👥 개발팀

BNSY Team

---

**문의사항이 있으시면 프로젝트 관리자에게 연락주세요.**
