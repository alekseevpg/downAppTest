import SwiftUI

@MainActor
struct SwipeableProfileCardView: View {

    private let cardMaxDragDistance = 80.0
    private let cardDragTreshold = 30.0

    @State private var cardOffset = CGSize.zero
    @State private var mainPageSelectionDisabled = false

    let profile: Profile
    let onSelectionChanged: ((SelectionType) -> Void)

    var body: some View {
        ProfileCardView(
            profile: profile,
            selectionType: .none,
            mainPageSelectionDisabled: $mainPageSelectionDisabled
        )
        .offset(y: cardOffset.height)
        .animation(.linear, value: cardOffset)
        .overlay {
            selectionGradientView
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 30)
                .onChanged { gesture in
                    mainPageSelectionDisabled = true

                    if abs(cardOffset.height) < cardMaxDragDistance {
                        cardOffset = gesture.translation
                    }
                }
                .onEnded { _ in
                    if abs(cardOffset.height) > cardMaxDragDistance {
                        if cardOffset.height > cardDragTreshold {
                            dateSelected(.hookup)
                        } else if cardOffset.height < -cardDragTreshold {
                            dateSelected(.date)
                        }
                    } else {
                        withAnimation {
                            cardOffset = .zero
                        }
                    }

                    mainPageSelectionDisabled = false
                }
        )
        .cornerRadius(10)
    }

    private var selectionGradientView: some View {
        Group {
            if cardOffset.height > cardDragTreshold {
                LinearGradient.hookupVertical
                    .overlay {
                        SelectionTypeView(type: .hookup)
                    }
            } else if cardOffset.height < -cardDragTreshold {
                LinearGradient.dateVertical
                    .overlay {
                        SelectionTypeView(type: .date)
                    }
            }
        }
        .allowsHitTesting(false)
    }

    private func dateSelected(_ selectionType: SelectionType) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                cardOffset = .zero
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                FeedbackGenerator.playFeedback(effect: .selection)
                onSelectionChanged(selectionType)
            }
        }
    }
}

#Preview {
    SwipeableProfileCardView(
        profile: Profile(
            name: "Jessica",
            userId: 13620229,
            age: 25,
            loc: "Ripon, CA",
            aboutMe: "baby stoner, + size \nbig boob haver and enjoyer\nlast pic is most recent :)",
            profilePicUrl: "https://down-static.s3.us-west-2.amazonaws.com/picks_filter/female_v2/pic00000.jpg"
        )
    ) { _ in }
        .background(Color.red)
}
