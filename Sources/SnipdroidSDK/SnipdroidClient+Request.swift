//
//  File.swift
//  
//
//  Created by Butanediol on 2023/7/27.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

extension SnipdroidClient {
    public func getRequestsFor(
        iconpack id: String,
        page: Int? = nil,
        per: Int? = nil
    ) async throws -> [Components.Schemas.Request_Created] {
        let response = try await self.client.getRequests(
            .init(
                query: .init(
                    iconpackid: id,
                    page: page,
                    per: per
                )
            )
        )
        
        switch response {
        case .ok(let okResponse):
            switch okResponse.body {
            case .json(let pageOfRequestList): return pageOfRequestList.items
            }
        case .code520(let errorResponse):
            switch errorResponse.body {
            case .json(let error): throw error
            }
        case .undocumented(let statusCode, _):
            throw Components.Schemas.ErrorMessage(error: true, reason: "\(statusCode)")
        }
    }
}
