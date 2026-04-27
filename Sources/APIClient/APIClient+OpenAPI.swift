//
//  APIClient+OpenAPI.swift
//  ArtemisCore
//
//  Created by Anian Schleyer on 25.04.26.
//

import Common
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

extension APIClient {

    /// API Client generated from OpenAPI Spec
    var generated: Client {
        Client(serverURL: baseUrl!,
               transport: URLSessionTransport(configuration: .init(session: session)))
    }

    public func call<T>(caller name: String = #function,
                        _ operation: (Client) async throws -> T,
                        currentTry: Int = 1) async -> DataState<T> {
        do {
            log.verbose(
                """
                ––––––––––––––––––––––––––––––––––––––––Request––––––––––––––––––––––––––––––––––––––––––
                \(name) using OpenAPI generated call
                –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                """)
            let res = try await operation(generated)
            return .done(response: res)
        } catch {
            let string = String(describing: error)

            // Retry if unauthorized, same behavior as in APIClient.swift
            // We cannot access status code directly because errors are internal types
            if currentTry < 3 && string.contains("response: undocumented(statusCode: 401") {
                return await call(caller: name, operation, currentTry: currentTry + 1)
            }

            log.error(
                """
                \n––––––––––––––––––––––––––––––––––––––Error––––––––––––––––––––––––––––––––––––––––––––––
                Generated API call by \(name) failed!
                Error: \(error)
                –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––\n
                """)
            return .failure(error: .init(title: error.localizedDescription))
        }
    }
}
