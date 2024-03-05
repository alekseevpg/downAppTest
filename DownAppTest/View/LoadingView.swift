import SwiftUI

struct LoadingView: View {

    @State private var isAnimating = false

    var body: some View {
        Image(systemName: "heart")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(.purple)
            .frame(width: 64)
            .transition(.opacity)
            .rotationEffect(/*@START_MENU_TOKEN@*/.zero/*@END_MENU_TOKEN@*/)
            .rotation3DEffect(isAnimating ? .degrees(360) : .zero, axis: (x: 0, y: 0, z: 1))
            .animation(
                Animation.easeInOut(duration: 2).repeatForever(autoreverses: false),
                value: isAnimating
            )
            .task {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isAnimating = true
                }
            }
    }
}

#Preview {
    LoadingView()
}
