import SwiftUI

@main
struct DownAppTestApp: App {

    private let asyncClient: AsyncRestClient
    private let profileService: ProfileService

    // MARK: - Init

    init() {
        let asyncClient = AsyncRestClient()

        self.asyncClient = asyncClient
        self.profileService = ProfileService(asyncClient: asyncClient)
    }

    var body: some Scene {
        WindowGroup {
            ProfilesScreen()
                .environmentObject(profileService)
        }
    }
}
