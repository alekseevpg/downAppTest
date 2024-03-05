import SwiftUI

struct ProfilesScreen: View {

    @EnvironmentObject private var profileService: ProfileService

    @State private var currentCardIndex = 0

    @State private var isLoading = true
    @State private var profiles: [SelectedProfile] = []
    @State private var backendError: BackendError?

    var body: some View {
        VStack {
            if isLoading {
                LoadingView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ProfilesView(profiles: profiles) {
                    Task {
                        await loadProfiles()
                    }
                }
            }
        }
        .background(Color.black)
        .task {
            await loadProfiles()
        }
        .emittingError($backendError)
    }

    private func loadProfiles() async {
        isLoading = true
        do {
            profiles = try await profileService
                .profiles()
                .map {
                    SelectedProfile(profile: $0, selectionType: .none)
                }
            print(profiles)
            currentCardIndex = 0
        } catch let error as BackendError {
            print(error)
        } catch {
            print(error)
        }
        isLoading = false
    }
}

#Preview {
    ProfilesScreen()
        .environmentObject(ProfileService(asyncClient: AsyncRestClient()))
}
