import SwiftUI

extension LinearGradient {

    static var dateVertical: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: Color.purple.opacity(0.6), location: 0),
                Gradient.Stop(color: Color.purple.opacity(0.2), location: 0.5),
                Gradient.Stop(color: Color.clear, location: 1),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
        )
    }

    static var hookupVertical: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: Color.clear, location: 0),
                Gradient.Stop(color: Color.orange.opacity(0.2), location: 0.5),
                Gradient.Stop(color: Color.orange.opacity(0.6), location: 1),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
        )
    }

    static var blackVertical: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: Color.clear, location: 0),
                Gradient.Stop(color: Color.black.opacity(0.2), location: 0.8),
                Gradient.Stop(color: Color.black.opacity(0.6), location: 1),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
        )
    }
}
