import SwiftUI
import NukeUI

@MainActor
struct AboutMeProfileView: View {
    
    let profile: Profile

    var body: some View {
        VStack {
            LazyImage(url: URL(string: profile.profilePicUrl ?? "")) { phase in
                if let image = phase.image {
                    ZStack {
                        GeometryReader { proxy in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: proxy.size.width, height: proxy.size.height)
                                .blur(radius: 50)
                        }
                        VStack(alignment: .center) {
                            Circle()
                                .stroke(lineWidth: 3)
                                .frame(width: 110, height: 110)
                                .overlay {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                }
                                .padding(.top, 64)

                            HStack(spacing: 8) {
                                Text(profile.name)
                                Text("·")
                                    .bold()
                                Text("\(profile.age)")
                            }
                            if let loc = profile.loc {
                                HStack {
                                    Image(systemName: "mappin.and.ellipse")
                                        .resizable()
                                        .frame(width: 10, height: 10)
                                    Text(loc)
                                        .font(.caption)
                                }
                            }

                            if let aboutMe = profile.aboutMe {
                                Text(aboutMe)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.center)
                                    .padding()
                            }
                            Spacer()
                        }
                        .foregroundStyle(.white)
                    }
                } else if phase.error != nil {
                    Color.red
                } else {
                    LoadingView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .background(Color.black.opacity(0.9))
    }
}

#Preview {
    AboutMeProfileView(
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
