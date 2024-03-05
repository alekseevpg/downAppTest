import Foundation

final class AsyncRestClient {

    private var session: URLSession = URLSession(configuration: .noCache)

    func load<T>(_ resource: Resource<T>, repeatCount: Int = 1) async throws -> T {
        let request = resource.urlRequest
        do {
            let data = try await session.dataTask(with: request)
            return try resource.parse(data)
        } catch let error as BackendError {
            let message = """
            Request failed
            \n
            Request: \(request)
            Body: \(String(decoding: request.httpBody ?? Data(), as: UTF8.self))
            \n
            Response: \(error)
            """
            print(message)
            let backendError = await mapStatusCodeError(error)
            if case .sadServer = backendError, repeatCount <= 3 {
                try await Task.sleep(s: TimeInterval(repeatCount * 5))
                return try await load(resource, repeatCount: repeatCount + 1)
            } else {
                throw backendError
            }
        } catch {
            let message = """
            Request failed
            \n
            Request: \(request)
            \n
            Response: \(error)
            """
            print(message)
            if let backendError = mapURLErrors(error) {
                throw backendError
            } else {
                throw error
            }
        }
    }

    // MARK: - Private methods

    private func mapStatusCodeError(_ error: BackendError) async -> BackendError {
        guard case .invalidHTTPStatusCode(let statusCode, _, _) = error else {
            return error
        }
        switch statusCode {
        case 400:
            return error
        default:
            return .sadServer
        }
    }

    private func mapURLErrors(_ error: Error) -> BackendError? {
        if let urlError = error as? URLError {
            if urlError.code == URLError.notConnectedToInternet || urlError.code == URLError.timedOut {
                return .badNetwork
            } else {
                return .urlError(urlError)
            }
        } else {
            return nil
        }
    }
}

// MARK: - URLSession (dataTask)

extension URLSession {
    fileprivate func dataTask(with request: URLRequest) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            dataTask(with: request) { data, response, error in
                if let error = error {
                    print("could not load \(String(describing: request.url))): \(error)")
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("could not load \(String(describing: request.url))): response not http")
                    continuation.resume(throwing: BackendError.noData)
                    return
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    break
                default:
                    let message: String
                    if let data = data,
                       let msg = String(data: data, encoding: .utf8) {
                        message = msg
                    } else {
                        message = "<no data>"
                    }
                    print("could not load \(String(describing: request.url))): invalid code \(httpResponse.statusCode) \(message as NSString)")
                    continuation.resume(
                        throwing: BackendError.invalidHTTPStatusCode(
                            code: httpResponse.statusCode,
                            url: request.url!,
                            message: message
                        )
                    )
                    return
                }

                guard let data else {
                    continuation.resume(throwing: BackendError.noData)
                    return
                }

                continuation.resume(returning: data)
            }.resume()
        }
    }
}

// MARK: - URLSessionConfiguration (noCache)

private extension URLSessionConfiguration {

    // MARK: - Internal properties
    
    static var noCache: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        return config
    }
}
