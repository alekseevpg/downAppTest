import SwiftUI
import NukeUI

@MainActor
struct ProfileView: View {

    let profile: Profile

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.9)
            LazyImage(url: URL(string: profile.profilePicUrl ?? "")) { phase in
                if let image = phase.image {
                    GeometryReader { proxy in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: proxy.size.width, height: proxy.size.height)
                    }
                } else if phase.error != nil {
                    Color.red
                        .overlay {
                            Text("Couldn't load the profile pic")
                                .font(.title)
                                .foregroundStyle(.white)
                                .padding()
                        }
                } else {
                    LoadingView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            LinearGradient.blackVertical
            HStack(spacing: 8) {
                Text(profile.name)
                Text("·")
                    .bold()
                Text("\(profile.age)")
                Spacer(minLength: 0)
            }
            .foregroundStyle(.white)
            .font(.title)
            .padding()
        }
    }

}

#Preview {
    ProfileView(
        profile: Profile(
            name: "Jessica",
            userId: 13620229,
            age: 25,
            loc: "Ripon, CA",
            aboutMe: "baby stoner, + size \nbig boob haver and enjoyer\nlast pic is most recent :)",
            profilePicUrl: "https://down-static.s3.us-west-2.amazonaws.com/picks_filter/female_v2/pic00000.jpg"
        )
    )
}

#Preview("Broken URL View") {
    ProfileView(
        profile: Profile(
            name: "Jessica",
            userId: 13620229,
            age: 25,
            loc: "Ripon, CA",
            aboutMe: "baby stoner, + size \nbig boob haver and enjoyer\nlast pic is most recent :)",
            profilePicUrl: "https://broken_url.jpg"
        )
    )
}
