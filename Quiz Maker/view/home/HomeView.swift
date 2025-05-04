import SwiftUI

struct HomeView: View {
    @Binding var topic: String
    @Binding var selectedDifficulty: String
    @Binding var selectedQuizType: String
    @Binding var selectedLanguage: String
    @Binding var selectedQuestionCount: String

    var onGenerateQuiz: () -> Void
    @FocusState private var isInputFocused: Bool
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Text("Quiz Maker")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 12)
            
            Divider().padding(.top, 8)
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 16) {
                        QuizOptionsCard(
                            topic: $topic,
                            selectedDifficulty: $selectedDifficulty,
                            selectedQuizType: $selectedQuizType,
                            selectedLanguage: $selectedLanguage,
                            selectedQuestionCount: $selectedQuestionCount
                        )
                    }
                    .padding(.horizontal)
                }

                NavigateToQuizButton(action: onGenerateQuiz)
            }
            .background(isDarkMode ?  Color(.systemGray6) : nil)
            .onTapGesture {
                isInputFocused = false
            }
        }
    }
}

private struct QuizOptionsCard: View {
    @Binding var topic: String
    @Binding var selectedDifficulty: String
    @Binding var selectedQuizType: String
    @Binding var selectedLanguage: String
    @Binding var selectedQuestionCount: String
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        VStack(spacing: 12) {
            TopicInputField(topic: $topic)
            
            VStack(alignment: .leading) {
                Text("label_difficulty")
                    .font(.caption)
                    .opacity(0.8)
                Selector(
                    options: ["option_easy", "option_medium", "option_hard"],
                    selectedOption: $selectedDifficulty
                )
            }

            VStack(alignment: .leading) {
                Text("label_quiz_type")
                    .font(.caption)
                    .opacity(0.8)
                Selector(
                    options: ["option_multiple_choice", "option_true_false"],
                    selectedOption: $selectedQuizType
                )
            }

            VStack(alignment: .leading) {
                Text("label_question_count")
                    .font(.caption)
                    .opacity(0.8)
                Selector(
                    options: ["5", "10", "15", "20"],
                    selectedOption: $selectedQuestionCount
                )
            }

            VStack(alignment: .leading) {
                Text("label_language")
                    .font(.caption)
                    .opacity(0.8)
                Selector(
                    options: ["option_turkish", "option_english"],
                    selectedOption: $selectedLanguage
                )
            }
        }
        .padding()
        .background(isDarkMode ? Color(.systemGray5) : Color(.systemGray6))
        .cornerRadius(16)
        .shadow(radius: 2)
        .padding(.horizontal)
        .padding(.top, 16)
    }
}

private struct TopicInputField: View {
    @Binding var topic: String
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("text_enter_topic", text: $topic)
                .textFieldStyle(.roundedBorder)
                .overlay(
                    HStack {
                        Spacer()
                        if !topic.isEmpty {
                            Button(action: {
                                topic = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 8)
                        }
                    }
                )
            
            HStack {
                Spacer()
                Text("\(topic.count) / 250")
                    .font(.footnote)
                    .foregroundColor(topic.count >= 250 ? .red : .gray)
            }
        }
    }
}

private struct NavigateToQuizButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            Text("btn_generate_quiz")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
        }
        .shadow(radius: 4)
        .padding(.horizontal, 34)
        .padding(.bottom, 18)
    }
}
