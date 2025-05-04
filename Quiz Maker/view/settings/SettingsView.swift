import SwiftUI

struct SettingsView: View {
    @State private var showDeleteOptions: Bool = false
    @State private var showQuizDeleteAlert = false
    @State private var showQuestionDeleteAlert = false
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("appLanguage") private var selectedLanguage: String = "en"
    
    @Environment(\.modelContext) private var context
    @State private var questionVM = QuestionViewModel()
    @State private var quizVM = QuizViewModel()

    var body: some View {
        VStack(spacing: 0) {
            SettingsLabel()
                .background(Color(.systemGroupedBackground))

            VStack(spacing: 24) {
                LanguageDropDown(
                    selectedLanguage: $selectedLanguage,
                    onLanguageChange: { lang in
                        selectedLanguage = lang

                        if lang == "Türkçe" {
                            UserDefaults.standard.set("tr", forKey: "appLanguage")
                        } else {
                            UserDefaults.standard.set("en", forKey: "appLanguage")
                        }

                        NotificationCenter.default.post(name: .languageDidChange, object: nil)
                    }
                )

                DarkModeToggle(
                    isDarkMode: $isDarkMode
                )

                Spacer()

                Divider()
                    .padding(.horizontal, 24)

                DeleteSavedDataButton {
                    showDeleteOptions = true
                }
            }
            .padding(.top, 16)
            .background(Color(.systemGray6))
        }
        .padding(.top, 16)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .confirmationDialog("text_delete_all_saved_data", isPresented: $showDeleteOptions, titleVisibility: .visible) {
            Button("btn_delete_quizzes", role: .destructive) {
                showQuizDeleteAlert = true
            }

            Button("btn_delete_questions", role: .destructive) {
                showQuestionDeleteAlert = true
            }

            Button("btn_cancel", role: .cancel) { }
        }
        .alert("title_delete_quizzes", isPresented: $showQuizDeleteAlert) {
            Button("btn_delete", role: .destructive) {
                quizVM.deleteAll(in: context)
                print("📛 Tüm quizler silindi.")
            }
            Button("btn_cancel", role: .cancel) { }
        } message: {
            Text("dialog_delete_quizzes_message")
        }
        .alert("title_delete_questions", isPresented: $showQuestionDeleteAlert) {
            Button("btn_delete", role: .destructive) {
                questionVM.deleteAll(in: context)
                print("📛 Tüm sorular silindi.")
            }
            Button("btn_cancel", role: .cancel) { }
        } message: {
            Text("dialog_delete_questions_message")
        }
    }
}

private struct LanguageDropDown: View {
    @Binding var selectedLanguage: String
    var onLanguageChange: (String) -> Void

    @State private var isExpanded = false

    let languages = ["English", "Türkçe"]
    
    var labelLanguage: String {
        selectedLanguage == "en" ? "English" : "Türkçe"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("label_language")
                .font(.callout)
                .foregroundColor(.secondary)

            Menu {
                ForEach(languages, id: \.self) { lang in
                    Button(lang) {
                        onLanguageChange(lang)
                    }
                }
            } label: {
                HStack {
                    Text(labelLanguage)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .cornerRadius(8)
            }
        }
        .padding(.horizontal, 24)
    }
}

private struct DarkModeToggle: View {
    @Binding var isDarkMode: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("label_theme")
                .font(.callout)
                .foregroundColor(.secondary)
            
            HStack {
                Text("label_dark_mode")
                    .foregroundColor(.primary)
                Spacer()
                Toggle("", isOn: $isDarkMode)
                    .labelsHidden()
            }
        }
        .padding(.horizontal, 24)
    }
}

private struct DeleteSavedDataButton: View {
    var onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            Text("btn_delete_items")
                .font(.subheadline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(.red.opacity(0.2))
                .foregroundColor(.red)
                .cornerRadius(8)
        }
        .padding(.horizontal, 26)
        .padding(.bottom, 20)
    }
}

private struct SettingsLabel: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey("label_settings"))
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)

            Divider()
                .padding(.horizontal, 16)
        }
    }
}


#Preview {
    SettingsView()
}
