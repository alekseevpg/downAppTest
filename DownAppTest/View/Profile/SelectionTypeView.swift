import SwiftUI

@MainActor
struct SelectionTypeView: View {
    
    let type: SelectionType

    var body: some View {
        HStack {
            type.image
            Text(type.rawValue.uppercased())
                .foregroundStyle(.white)
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

enum SelectionType: String {
    case none
    case date
    case hookup

    @ViewBuilder
    var image: some View {
        switch self {
        case .none:
            EmptyView()
        case .date:
            Image(systemName: "heart.fill")
                .foregroundStyle(Color.purple)
        case .hookup:
            Image(systemName: "flame")
                .foregroundStyle(Color.orange)
        }
    }
}

#Preview {
    VStack {
        SelectionTypeView(type: .date)
        SelectionTypeView(type: .hookup)
        Spacer()
    }
    .frame(maxWidth: .infinity)
    .background(Color.black)
}
