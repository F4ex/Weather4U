# Project Convention

- iOS 15.x 버전으로 설정 후 개발하기
    - 최신의 버전 사용보다는 이미 검증받은 버전 위주로 사용하는 것이 오류가 적다고 생각해서
- Stroyboard 없이 코드베이스로 UI 구현하기
    - merge시 conflict를 최소화 하기 위해서
- AlamoFire, SnapKit, Then, KingFisher 패키지 사용
    - 코드의 복잡성을 줄이기 위해 사용
- 필수로 작성하게 될 함수명 통일하기
    - private func configureUI()
        - ➡️ UIButton이나 UILabel 등과 같은 부분 초기 설정 함수
    - private func constraintLayout()
        - ➡️ UIButton이나 UILabel 등과 같은 부분 제약조건 설정 함수
- ViewController 파일명 직관적으로 작성하기
    - ex) MainViewController, WeatherCollectionViewCell
- ‼️ 모르는 것이나 같이 정해야 되는 부분이 있으면 팀원들과 소통하기

## Code Convention
1. 네이밍 규칙:

```swift
- 클래스, 구조체, 열거형 이름은 UpperCamelCase를 사용합니다.
- 함수, 변수, 상수 이름은 lowerCamelCase를 사용합니다.
- 약어는 모두 대문자로 표기합니다.  ex) URL, ID
- 변수명, 함수명, 상수명은 직관적으로 작성합니다.  ex) let verticalStackView
```

2. 들여쓰기 및 공백:

```swift
- 들여쓰기는 탭(Tab)키를 사용합니다.
- 콜론(:) 앞에는 공백을 넣지 않고, 콜론 뒤에는 공백을 추가합니다.
- 연산자 앞뒤로 공백을 추가합니다.
- 쉼표(,) 뒤에는 공백을 추가합니다.
```

3. Import

```swift
- 모듈 임포트는 알파벳 순으로 정렬합니다.  ex) import AlamoFire import UIKit
```

4. 그 외 규칙

```swift
- guard 문을 사용하여 옵셔널 바인딩과 조건 검사를 수행합니다.
- 타입 추론을 활용하되, 명시적으로 타입을 지정해야 할 때는 지정합니다.
- 프로토콜 채택 시 extension을 사용하여 관련 메서드를 그룹화합니다.
```

## Github Rules

### **깃허브 규칙**

- develop 브랜치에서 새로운 브랜치 생성 후 개발하기
- 구현할 기능들을 Issue로 작성해, commit 할때 이슈 번호를 포함 시키기
    - ex) [Feature] 검색 기능 구현 #5
- PR은 develop 브랜치로 보내기
- 작성된 PR을 혼자서 merge하지 않기

### 깃헙 커밋 규칙

| 작업 타입 | 작업내용 |
| --- | --- |
| [Feature] | 새로운 기능 구현 |
| [Design] | 레이아웃 조정 |
| [Fix] | 버그, 오류 해결, 코드 수정 |
| [Add] | [Feature] 이외의 코드 추가, 라이브러리 추가, 새로운 View 생성 |
| [Delete] | 쓸모없는 코드, 주석 삭제 |
| [Remove] | 파일 삭제 |
| [Merge] | 머지 |

ex) [Feature] 검색 기능 추가
