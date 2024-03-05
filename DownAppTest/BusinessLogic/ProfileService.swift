import Foundation

enum ProfileServiceError: Error {
    case wrongURL
}

final class ProfileService: ObservableObject {

    private let asyncClient: AsyncRestClient

    init(asyncClient: AsyncRestClient) {
        self.asyncClient = asyncClient
    }

    func profiles() async throws -> [Profile] {
        guard let url = URL(string: "https://raw.githubusercontent.com/downapp/sample/main/sample.json") else {
            throw ProfileServiceError.wrongURL
        }
        let resource = Resource<[Profile]>(get: url)
        return try await asyncClient.load(resource)
    }
}
