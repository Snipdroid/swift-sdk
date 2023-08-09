import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

public class SnipdroidClient {
    let client: Client
    
    public init(serverUrl: URL) {
        self.client = Client(
            serverURL: serverUrl,
            transport: URLSessionTransport()
        )
    }
    
    public enum QueryType {
        case plain(String)
        case regex(String)
    }
    
    /// Query app infomation from server
    public func getAppInfo(
        query: QueryType,
        page: Components.Parameters.page? = nil,
        per: Components.Parameters.per? = nil
    ) async throws -> Components.Schemas.PageOfAppInfoList {
        
        var searchQuery: Operations.getAppInfo.Input.Query {
            switch query {
            case .plain(let searchText):
                return .init(q: searchText, page: page, per: per)
            case .regex(let regexPattern):
                return .init(regex: regexPattern, page: page, per: per)
            }
        }
        
        let response = try await client.getAppInfo(
            .init(query: searchQuery)
        )
        
        switch response {
        case .ok(let okResponse):
            switch okResponse.body {
            case .json(let pageOfAppInfoList):
                return pageOfAppInfoList
            }
        case .code520(let errorResponse):
            switch errorResponse.body {
            case .json(let error):
                throw error
            }
        case .undocumented(statusCode: let statusCode, _):
            throw Components.Schemas.ErrorMessage(error: true, reason: "\(statusCode)")
        }
    }
    
    /// Upload new app infomation to server
    public func uploadAppInfo(_ apps: [Components.Schemas.AppInfo_Create]) async throws -> [Components.Schemas.AppInfo] {
        let response = try await client.uploadAppInfo(.init(body: .json(apps)))
        
        switch response {
        case .ok(let okResponse):
            switch okResponse.body {
            case .json(let uploadedApps): return uploadedApps
            }
        case .code520(let errorResponse):
            switch errorResponse.body {
            case .json(let error):
                throw error
            }
        case .undocumented(let statusCode, _):
            throw Components.Schemas.ErrorMessage(error: true, reason: "\(statusCode)")
        }
    }
    
    public func getIcon(packageName: String) async throws -> Data {
        let response = try await client.getIcon(.init(query: .init(packageName: packageName)))
        
        switch response {
        case .ok(let okResponse):
            switch okResponse.body {
            case .binary(let data): return data
            }
        case .undocumented(let statusCode, _):
            throw Components.Schemas.ErrorMessage(error: true, reason: "\(statusCode)")
        }
    }
    
    func userLoginWith(username: String, _ password: String) async throws -> Components.Schemas.UserToken {
        
        guard let encodedCredential = "\(username):\(password)"
            .data(using: .utf8)?
            .base64EncodedString() else {
            throw Client.Error.base64EncodingError
        }
        
        let headers = Operations.userLogin.Input.Headers(Authorization: "Basic \(encodedCredential)")
        
        return try await userLogin(headers: headers)
    }
    
    func userLoginWith(token: String) async throws -> Components.Schemas.UserToken {
        let headers = Operations.userLogin.Input.Headers(Authorization: "Bearer \(token)")
        
        return try await userLogin(headers: headers)
    }
    
    
    private func userLogin(headers: Operations.userLogin.Input.Headers) async throws -> Components.Schemas.UserToken {
        let response = try await client.userLogin(.init(headers: headers))
        
        switch response {
        case .ok(let okResponse):
            switch okResponse.body {
            case .json(let token):
                return token
            }
        case .undocumented(let statusCode, _):
            throw Components.Schemas.ErrorMessage(error: true, reason: "\(statusCode)")
        }
    }
}

