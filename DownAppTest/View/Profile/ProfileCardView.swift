import SwiftUI

@MainActor
struct ProfileCardView: View {

    private let cornerRadius = 10.0

    @State private var mainPageSelected = true

    let profile: Profile
    let selectionType: SelectionType

    @Binding var mainPageSelectionDisabled: Bool

    var body: some View {
        VStack {
            Group {
                if mainPageSelected {
                    ProfileView(profile: profile)
                } else {
                    AboutMeProfileView(profile: profile)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .cornerRadius(cornerRadius)
            .overlay {
                pageTypeButtons
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.gray, lineWidth: 1)
                selectionGradientView
            }
        }
        .overlay(alignment: .top) {
            Group {
                if profile.aboutMe != nil {
                    pageTypeIndicatorView
                }
            }
        }
        .cornerRadius(cornerRadius)
    }

    private var pageTypeIndicatorView: some View {
        HStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 5)
                .foregroundStyle(Color.white.opacity(mainPageSelected ? 0.8 : 0.3))
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 5)
                .foregroundStyle(Color.white.opacity(mainPageSelected ? 0.3 : 0.8))
        }
        .padding()
    }

    private var pageTypeButtons: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation {
                    if !mainPageSelected {
                        mainPageSelected = true
                        FeedbackGenerator.playFeedback(effect: .impact(style: .light))
                    }
                }
            } label: {
                VStack { }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.clear)
            }
            Button {
                withAnimation {
                    if mainPageSelected {
                        mainPageSelected = false
                        FeedbackGenerator.playFeedback(effect: .impact(style: .light))
                    }
                }
            } label: {
                VStack { }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.clear)
            }
        }
        .disabled(mainPageSelectionDisabled)
    }

    private var selectionGradientView: some View {
        Group {
            switch selectionType {
            case .date:
                LinearGradient.dateVertical
                    .overlay {
                        SelectionTypeView(type: .date)
                    }
            case .hookup:
                LinearGradient.hookupVertical
                    .overlay {
                        SelectionTypeView(type: .hookup)
                    }
            case .none:
                EmptyView()
            }
        }
        .allowsHitTesting(false)
    }
}

#Preview("None") {
    ProfileCardView(
        profile: Profile(
            name: "Jessica",
            userId: 13620229,
            age: 25,
            loc: "Ripon, CA",
            aboutMe: "baby stoner, + size \nbig boob haver and enjoyer\nlast pic is most recent :)",
            profilePicUrl: "https://down-static.s3.us-west-2.amazonaws.com/picks_filter/female_v2/pic00000.jpg"
        ),
        selectionType: .none,
        mainPageSelectionDisabled: .constant(false)
    )
}

#Preview("Date") {
    ProfileCardView(
        profile: Profile(
            name: "Jessica",
            userId: 13620229,
            age: 25,
            loc: "Ripon, CA",
            aboutMe: "baby stoner, + size \nbig boob haver and enjoyer\nlast pic is most recent :)",
            profilePicUrl: "https://down-static.s3.us-west-2.amazonaws.com/picks_filter/female_v2/pic00000.jpg"
        ),
        selectionType: .date,
        mainPageSelectionDisabled: .constant(false)
    )
}

#Preview("Hookup") {
    ProfileCardView(
        profile: Profile(
            name: "Jessica",
            userId: 13620229,
            age: 25,
            loc: "Ripon, CA",
            aboutMe: "baby stoner, + size \nbig boob haver and enjoyer\nlast pic is most recent :)",
            profilePicUrl: "https://down-static.s3.us-west-2.amazonaws.com/picks_filter/female_v2/pic00000.jpg"
        ),
        selectionType: .hookup,
        mainPageSelectionDisabled: .constant(false)
    )
}
