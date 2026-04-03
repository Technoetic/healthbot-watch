import SwiftUI
import WatchKit

@main
struct HealthBotWatchApp: App {

    @WKApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - App Delegate (Background Task 처리)

class AppDelegate: NSObject, WKApplicationDelegate {

    private let backgroundTaskID = "com.healthbot.watch.upload"

    func applicationDidFinishLaunching() {
        scheduleBackgroundUpload()
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            switch task {
            case let refreshTask as WKApplicationRefreshBackgroundTask:
                performBackgroundUpload {
                    refreshTask.setTaskCompletedWithSnapshot(false)
                    self.scheduleBackgroundUpload()
                }
            default:
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }

    private func scheduleBackgroundUpload() {
        let settings = SettingsStore.shared
        guard settings.autoUploadEnabled && settings.isConfigured else { return }

        let intervalMinutes = settings.uploadIntervalMinutes
        let fireDate = Date().addingTimeInterval(TimeInterval(intervalMinutes * 60))

        WKExtension.shared().scheduleBackgroundRefresh(
            withPreferredDate: fireDate,
            userInfo: nil
        ) { _ in }
    }

    private func performBackgroundUpload(completion: @escaping () -> Void) {
        let settings = SettingsStore.shared
        guard settings.autoUploadEnabled && settings.isConfigured else {
            completion()
            return
        }

        let health = HealthManager.shared
        health.requestAuthorization { granted in
            guard granted else {
                completion()
                return
            }
            health.collectAndUpload(
                token: settings.token,
                serverURL: settings.serverURL
            )
            // 전송 완료 대기 (최대 25초)
            DispatchQueue.main.asyncAfter(deadline: .now() + 25) {
                completion()
            }
        }
    }
}
