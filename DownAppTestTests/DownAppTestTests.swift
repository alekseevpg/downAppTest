import XCTest
@testable import DownAppTest

final class DownAppTestTests: XCTestCase {

    func testProfileEndpointIsCorrect() async throws {
        let asyncRestClient = AsyncRestClient()
        let profileService = ProfileService(asyncClient: asyncRestClient)

        let profiles = try? await profileService.profiles()
        
        XCTAssertEqual(profiles?.isEmpty ?? true, false)
    }
}
