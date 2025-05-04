import SwiftUI

struct MainView: View {

    @State var appMainTabBarSelection: Int
    @State private var showQuizScreen = false

    @State private var topic: String = ""
    @State private var selectedDifficulty: String = "option_medium"
    @State private var selectedQuizType: String = "option_multiple_choice"
    @State private var selectedLanguage: String = "option_turkish"
    @State private var selectedQuestionCount: String = "5"

    var body: some View {
        NavigationStack {
            VStack {
                switch appMainTabBarSelection {
                case 1:
                    SettingsView()
                case 2:
                    HomeView(
                        topic: $topic,
                        selectedDifficulty: $selectedDifficulty,
                        selectedQuizType: $selectedQuizType,
                        selectedLanguage: $selectedLanguage,
                        selectedQuestionCount: $selectedQuestionCount,
                        onGenerateQuiz: {
                            showQuizScreen = true
                        }
                    )
                case 3:
                    SavedView()
                default:
                    HomeView(
                        topic: $topic,
                        selectedDifficulty: $selectedDifficulty,
                        selectedQuizType: $selectedQuizType,
                        selectedLanguage: $selectedLanguage,
                        selectedQuestionCount: $selectedQuestionCount,
                        onGenerateQuiz: {
                            showQuizScreen = true
                        }
                    )
                }

                MainTabView(appMainTabBarSelection: $appMainTabBarSelection)
                    .padding(.top, -10)
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationDestination(isPresented: $showQuizScreen) {
                QuizScreen(
                    topic: topic,
                    difficulty: selectedDifficulty,
                    testType: selectedQuizType,
                    language: selectedLanguage,
                    count: selectedQuestionCount
                )
            }
        }
    }
}
