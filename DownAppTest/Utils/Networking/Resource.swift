import Foundation

enum HttpError: LocalizedError {
    case invalidResponse
    case invalidStatusCode(code: Int)
}

struct Resource<A> {

    var urlRequest: URLRequest
    let parse: (Data) throws -> A

    var url: URL {
        urlRequest.url!
    }
}

extension Resource {
    func map<B>(_ transform: @escaping (A) throws -> B) rethrows -> Resource<B> {
        return Resource<B>(urlRequest: urlRequest) { try transform(self.parse($0)) }
    }
}

extension Resource: CustomStringConvertible {
    var description: String {
        "URL: \(urlRequest.httpMethod ?? "") \(urlRequest.url!)"
    }
}

extension Resource where A: Decodable {
    init(get url: URL) {
        self.urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        self.parse = { data in
            return try JSONDecoder().decode(A.self, from: data)
        }
    }
}
