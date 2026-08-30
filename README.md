# MyApp

Starter app iOS bằng SwiftUI, XcodeGen, Firebase và SwiftData.

Dự án này được tổ chức theo cấu trúc clean-ish và phù hợp để làm nền cho app iOS mới.

## Mục tiêu

- Khởi tạo app iOS nhanh
- Quản lý project bằng XcodeGen thay vì chỉnh `.xcodeproj` trực tiếp
- Có sẵn theme, components, onboarding flow và service cơ bản
- Dễ triển khai CI trên GitHub Actions

## Cấu trúc project

```text
.
├── .github/
│   └── workflows/
│       └── ios-build.yml
├── ios/
│   ├── project.yml
│   └── MyApp/
│       ├── App/
│       ├── Data/
│       ├── Design/
│       ├── Features/
│       ├── Navigation/
│       ├── Resources/
│       └── Services/
├── README.md
└── .gitignore
```

## Yêu cầu

Trên máy local:

- macOS
- Xcode
- Homebrew
- XcodeGen

Cài đặt XcodeGen:

```bash
brew install xcodegen
```

## Bắt đầu nhanh

### 1. Generate project

```bash
cd ios
xcodegen generate
```

### 2. Mở trong Xcode

```bash
open MyApp.xcodeproj
```

### 3. Chạy app

- Chọn simulator iPhone / iPad
- Bấm Run trong Xcode

## Tùy chỉnh app

### Đổi tên app nhanh bằng CMD (Windows)

Nếu muốn đổi tên từ `MyApp` sang tên mới trên Windows, dùng các lệnh sau:

```cmd
set NEW_NAME=MyNewApp

rem 1) đổi tên thư mục project
ren ios\MyApp %NEW_NAME%

rem 2) đổi tên file Swift app entry nếu có
ren ios\%NEW_NAME%\App\MyAppApp.swift %NEW_NAME%App.swift

rem 3) đổi tên trong file project.yml
powershell -NoProfile -Command "(Get-Content ios\project.yml) -replace 'name: MyApp', 'name: %NEW_NAME%' | Set-Content ios\project.yml"
powershell -NoProfile -Command "(Get-Content ios\project.yml) -replace 'MyApp', '%NEW_NAME%' | Set-Content ios\project.yml"

rem 4) đổi tất cả text MyApp thành tên mới trong toàn bộ project
powershell -NoProfile -Command "Get-ChildItem -Path ios -Recurse -File | Where-Object { $_.Extension -in '.swift', '.yml', '.plist', '.entitlements' } | ForEach-Object { $p = $_.FullName; $content = Get-Content $p -Raw; $new = $content.Replace('MyApp', '%NEW_NAME%'); if ($new -ne $content) { Set-Content -Path $p -Value $new -NoNewline } }"

rem 5) regenerate Xcode project
cd ios
xcodegen generate
```

> Đây là cách nhanh để đổi tên project, tên folder, tên file, và text trong file cùng lúc cho phù hợp với project mới.

> Sau đó bạn nên kiểm tra lại các mục sau:
> - `PRODUCT_BUNDLE_IDENTIFIER` trong `ios/project.yml`
> - `DEVELOPMENT_TEAM`
> - tên file app entry nếu có `App.swift`
> - tên scheme trong Xcode nếu cần cập nhật thủ công

### Đổi Bundle ID

Trong `ios/project.yml`, chỉnh:

```yaml
PRODUCT_BUNDLE_IDENTIFIER: com.truongdx.myapp
```

### Đổi team Apple

Trong `ios/project.yml`:

```yaml
DEVELOPMENT_TEAM: #YOUR_TEAM_ID
```

## Build với XcodeGen

Sau khi sửa `project.yml`, luôn chạy lại:

```bash
cd ios
xcodegen generate
```

## GitHub Actions

Project có workflow build iOS ở:

- [.github/workflows/ios-build.yml](.github/workflows/ios-build.yml)

Workflow này chạy trên GitHub-hosted macOS runner, generate project bằng XcodeGen, và build app trên simulator.

## Tính năng có sẵn

- SwiftUI app shell
- Design system cơ bản
- Components tái sử dụng
- Onboarding flow
- SwiftData schema
- Firebase package setup
- Remote config / analytics / notification service scaffold

## Lưu ý

- Đây là template khởi tạo, chưa phải app hoàn chỉnh theo nghiệp vụ cụ thể.
- GitHub Actions chỉ phù hợp cho build/test trên simulator.
- Chạy trên thiết bị thật cần Apple Developer account và code signing.

## Kích hoạt CI trên GitHub

```bash
git add .
git commit -m "setup iOS CI"
git push origin main
```

Sau đó vào GitHub → Actions → chọn workflow `iOS Build` → Run workflow.

## Liên hệ / tiếp tục phát triển

Bạn có thể chỉnh tiếp project này để thêm:

- authentication
- tab bar / app navigation
- API layer
- paywall / subscription
- Test target
- release workflow