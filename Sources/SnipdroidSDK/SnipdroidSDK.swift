import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

class SnipdroidClient {
    private let client: Client
    
    init(serverUrl: URL) {
        self.client = Client(
            serverURL: serverUrl,
            transport: URLSessionTransport()
        )
    }
    
    enum QueryType {
        case plain(String)
        case regex(String)
    }
    
    func getAppInfo(
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
}
