import UIKit

@MainActor
struct FeedbackGenerator {
    static func playFeedback(effect: HapticKind) {
        switch effect {
        case .impact(let style):
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.impactOccurred()
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }
}

enum HapticKind {
    case impact(style: UIImpactFeedbackGenerator.FeedbackStyle)
    case selection
}
