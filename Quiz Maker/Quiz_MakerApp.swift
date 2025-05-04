import SwiftUI
import SwiftData

@main
struct Quiz_MakerApp: App {
    
    // Shared SwiftData model container for Question and Quiz models.
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Question.self,
            Quiz.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    // Stores dark mode preference.
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    // Stores app language preference ("en", "tr").
    @AppStorage("appLanguage") private var appLanguage: String = "en"

    // Used to reset the view hierarchy when language changes.
    @State private var resetViewId = UUID()
    // Default tab index for MainView (e.g., Home = 2).
    @State private var initialTabSelection: Int = 2

    var body: some Scene {
        WindowGroup {
            MainView(appMainTabBarSelection: initialTabSelection)
                .id(resetViewId) // Force re-render on language change.
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .environment(\.locale, Locale(identifier: UserDefaults.standard.string(forKey: "appLanguage") ?? "tr"))
                .onReceive(NotificationCenter.default.publisher(for: .languageDidChange)) { _ in
                    // When language changes, switch to Settings tab and refresh view.
                    initialTabSelection = 1
                    resetViewId = UUID()
                }
        }
        .modelContainer(sharedModelContainer) // Inject SwiftData container.
    }
}
