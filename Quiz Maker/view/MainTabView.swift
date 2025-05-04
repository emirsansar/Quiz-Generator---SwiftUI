import SwiftUI

struct MainTabView: View {
    @Binding var appMainTabBarSelection: Int
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack {
                TabBarButton(iconName: "gearshape.fill", title: "nav_settings", selectedTab: $appMainTabBarSelection, tabIndex: 1)
                    .padding(.leading, 30)
                
                Spacer()
                
                TabBarButton(iconName: "house.fill", title: "nav_home", selectedTab: $appMainTabBarSelection, tabIndex: 2)

                Spacer()

                TabBarButton(iconName: "bookmark.fill", title: "nav_saved", selectedTab: $appMainTabBarSelection, tabIndex: 3)
                    .padding(.trailing, 30)
            }
            .padding()
            .background(Color(.systemGray6))
        }

    }
}

private struct TabBarButton: View {
    let iconName: String
    let title: LocalizedStringKey
    @Binding var selectedTab: Int
    let tabIndex: Int

    var body: some View {
        Button(action: {
            selectedTab = tabIndex
        }) {
            VStack {
                Image(systemName: iconName)
                    .font(.system(size: 20))
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(selectedTab == tabIndex ? .blue : .gray)
        }
        .frame(width: 80)
    }
}

#Preview {
    MainTabView(appMainTabBarSelection: .constant(1))
}
