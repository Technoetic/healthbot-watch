import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "applewatch")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("HealthBot")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Apple Watch 앱을 확인하세요")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Text("이 앱은 Watch 앱의 설치를 위한 컴패니언입니다.\n건강 데이터 전송은 Watch에서 직접 이루어집니다.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}
