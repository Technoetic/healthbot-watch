import SwiftUI

/// iPhone companion 앱 — Watch 앱 설치를 위한 최소 래퍼
/// 실제 기능은 Watch 앱에서 처리되므로 이 앱은 빈 상태로 유지
@main
struct iOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
