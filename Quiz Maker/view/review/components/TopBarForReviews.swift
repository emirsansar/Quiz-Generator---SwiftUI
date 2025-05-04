import SwiftUI

struct TopBarForReviews: View {
    let title: LocalizedStringKey
    @Binding var showMenu: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .bold()

            Spacer()

            Button {
                showMenu = true
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.title2)
                    .foregroundColor(.primary)
                    .padding(8)
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
}
