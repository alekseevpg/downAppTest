import SwiftUI

struct ProfilesView: View {
    
    @State private var currentCardIndex = 0

    @State var profiles: [SelectedProfile]
    let onResetClicked: (() -> Void)

    var body: some View {
        TabView(selection: $currentCardIndex) {
            ForEach(Array(zip(profiles.indices, profiles)), id: \.0) { index, profile in
                Group {
                    switch profile.selectionType {
                    case .date, .hookup:
                        ProfileCardView(
                            profile: profile.profile,
                            selectionType: profile.selectionType,
                            mainPageSelectionDisabled: .constant(false)
                        )
                    case .none:
                        SwipeableProfileCardView(
                            profile: profile.profile
                        ) { selectionType in
                            currentCardIndex += 1
                            if let index = profiles.firstIndex(where: { $0 == profile }) {
                                profiles[index].selectionType = selectionType
                            }
                        }
                    }
                }
                .tag(index)
                .padding()
            }
            NoProfileView(onResetClicked: onResetClicked)
                .padding()
                .tag(profiles.count)
        }
        .padding(.bottom)
        .animation(.easeInOut, value: currentCardIndex)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .background(Color.black)
    }
}
#Preview {
    ProfilesView(
        profiles: [
            SelectedProfile(
                profile: Profile(
                    name: "Jessica",
                    userId: 13620229,
                    age: 25,
                    loc: "Ripon, CA",
                    aboutMe: "baby stoner, + size \nbig boob haver and enjoyer\nlast pic is most recent :)",
                    profilePicUrl: "https://down-static.s3.us-west-2.amazonaws.com/picks_filter/female_v2/pic00000.jpg"
                ),
                selectionType: .none
            ),
            SelectedProfile(
                profile: Profile(
                    name: "Jessica",
                    userId: 13620239,
                    age: 25,
                    loc: "Ripon, CA",
                    aboutMe: "baby stoner, + size \nbig boob haver and enjoyer\nlast pic is most recent :)",
                    profilePicUrl: "https://down-static.s3.us-west-2.amazonaws.com/picks_filter/female_v2/pic00000.jpg"
                ),
                selectionType: .none
            )
        ],
        onResetClicked: {
        }
    )
}
