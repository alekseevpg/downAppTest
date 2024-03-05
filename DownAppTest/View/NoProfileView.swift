import SwiftUI

struct NoProfileView: View {

    let onResetClicked: (() -> Void)

    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 100, height: 100)
                .padding(.bottom)
            Text("No more profiles")
                .font(.largeTitle)
            Text("That's all for now, bun't don't worry, you can find more in the original Down App.")
                .multilineTextAlignment(.center)
                .font(.headline)
                .padding(.horizontal)

            Spacer()
            Button {
                onResetClicked()
            } label: {
                Text("Reset Search")
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            .padding()
            
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(.white)
        .background(Color.black.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray, lineWidth: 1)
        )
    }
}

#Preview {
    NoProfileView() { }
}
