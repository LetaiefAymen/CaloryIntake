//
//  HTTPClient.swift
//  FoodItemsApi
//
//  Created by Aymen Letaief on 2024-11-10.
//

import Foundation

public protocol HTTPClient {
    func loadURL(url: URL) async throws -> (Data, URLResponse)
}

public final class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public func loadURL(url: URL) async throws -> (Data, URLResponse) {
        try await session.data(from: url)
    }
}
