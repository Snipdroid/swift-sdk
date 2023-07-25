import XCTest
@testable import SnipdroidSDK

let serverUrl = URL(string: "https://apptracker-dev.cn2.tiers.top/api")!

final class SnipdroidSDKTests: XCTestCase {
    func testGetAppInfo() async throws {
        let client = SnipdroidClient(serverUrl: serverUrl)
        
        let _ = try await client.getAppInfo(query: .plain("QQ"))
    }
    
    func testUploadAppInfo() async throws {
        let client = SnipdroidClient(serverUrl: serverUrl)
        
        let _ = try await client.uploadAppInfo([
            .init(appName: "Test App", packageName: "com.example.testApp", activityName: "com.example.testApp.MAIN_ACTIVITY")
        ])
    }
}
