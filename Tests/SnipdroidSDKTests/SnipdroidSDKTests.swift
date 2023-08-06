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
    
    func testGetRequest() async throws {
        let client = SnipdroidClient(serverUrl: serverUrl)
        
        let _ = try await client.getRequestsFor(iconpack: "7D2E8FA0-8460-4DD0-A1EC-C6BA2C70A573")
    }
    
    func testGetIcon() async throws {
        let client = SnipdroidClient(serverUrl: serverUrl)
        
        let data = try await client.getIcon(packageName: "com.tencent.mobileqq")
        XCTAssertEqual(data.count, 18090)
    }
}
