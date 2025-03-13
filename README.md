# BBamBBam
## 졸음 운전 예방 앱
- face detection으로 실시간 운전자의 행동을 모니터링하고 졸음운전 사전 징후가 감지되면, 알람이 울려 졸음 운전을 직접적으로 방지할 수 있습니다.
  -  EAR(Eye Aspect Ratio)를 측정하여 눈을 감은 상태가 2초 이상 지속되면 졸음 운전 사전 징후로 판단하여 알람음을 울립니다.
- 운전을 할 때마다 졸음 운전 사전 징후를 기록하여 안전한 운전을 하고 있는지 스스로 확인할 수 있는 report를 제공합니다.

## 기획의도
 졸음운전은 운전자 본인뿐 아니라 주변 차량과 보행자의 안전에 큰 위협이 되곤 합니다. 특히 화물차 운전자의 졸음 운전은 더 큰 사고를 유발할 수 있습니다. 화물차 운전자 졸음 운전과 관련하여 많은 대책들이 제안되었지만, 현실적으로 화물차 운전자가 이용하기 어려운 상황이거나 특정한 기기가 있어야 한다는 문제가 있었습니다. 이러한 문제점을 개선하여, 졸음 운전을 사전에 방지할 수 있도록 접근성이 높은 스마트폰 앱을 활용하여 졸음 운전 예방 앱을 개발하였습니다.

## 프로젝트 기간
2024.4 ~2024.8

## 기술
- Framework: Flutter
- State Management: GetX
- Backend & Database: Firebase (Auth, Firestore, Storage)
- AI: TensorFlow Lite, Google ML Kit

## Pages
| login | sign up |
|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/ec641ed8-b89b-4db5-82eb-b1846ee8adbd" width="250"/> | <img src="https://github.com/user-attachments/assets/8a7a2857-4130-4681-bba5-3883d3d53aa6" width="250"/> |
| 뺌뺌 로그인 화면입니다. 기존 계정이 있다면 로그인, 없다면 회원가입으로 뺌뺌을 이용할 수 있습니다. | 회원가입은 이메일과 닉네임, 비밀번호 입력으로 가입할 수 있습니다. 원할 경우, 프로필 이미지를 선택할 수 있습니다. |

| home | mypage |
|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/f3bf4097-2339-4bf6-b8b7-d233366c6d08" width="250"/> | <img src="https://github.com/user-attachments/assets/88c901d9-4cb9-4b66-9df5-4dc12d801c39" width="250"/> |
| home 화면의 start 버튼을 눌러 졸음 운전 감지를 시작할 수 있습니다. 우측 하단의 report 버튼을 누를 경우 report가 보여집니다. | 사용자의 개인 정보 확인, 수정, 로그아웃 등 개인 정보를 관리할 수 있는 화면입니다. 문의하기를 통해 개발자에게 문의할 수 있는 기능도 포함됩니다. |

| camera | camera detection |
|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/1f7ca7c5-2604-4dd7-bfa5-a351de41ca21" width="250"/> | <img src="https://github.com/user-attachments/assets/fac61d4c-93c8-4c34-a139-f85a53b9f555" width="250"/> |
| 운전 시작하기 진입 시, 졸음운전 탐지 가이드가 보여집니다. 총 3단계로 주어지며 사용자가 충분한 숙지 후 졸음운전 탐지를 시작할 수 있도록 합니다. | 사용자가 졸음운전 탐지로 판단 될 경우, 경고 음성과 함께 졸음 운전 경고 캐릭터가 보이게 되며, 졸음 운전 횟수가 1 증가합니다. 사용자는 STOP 버튼을 통해 졸음 운전 탐지 및 운전 시간을 정지할 수 있습니다. |

| report | report details |
|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/bd6a4cf3-6c79-465e-af68-fd10a11736b0" width="250"/> | <img src="https://github.com/user-attachments/assets/83df17a9-d6c5-4fb8-90ee-1111c278c80c" width="250"/> |
| 날짜 별로 졸음 운전 기록을 확인할 수 있는 리포트 화면입니다. 캘린더 형태로 직관적으로 확인 가능합니다. | 운전 기록 별로 졸음 운전 여부를 확인할 수 있습니다. 졸음 운전 횟수가 1 이상이라면 졸음 운전 기록으로 표시되며, 졸음 운전 타임 스탬프를 확인 가능합니다. 졸음 운전을 하지 않았을 경우, 정상 운전으로 표기됩니다. |

## Collaborators
| 임소현 | 최지애 |
|:---:|:---:|
|login, mypage, user db, info|home, report, camera detection| 
