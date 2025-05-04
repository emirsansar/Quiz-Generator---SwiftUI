import SwiftUI

struct SavedView: View {
    @Environment(\.modelContext) private var context
    @State private var quizViewModel = QuizViewModel()
    @State private var questionViewModel = QuestionViewModel()
    
    @State private var selectedTab = "Quizzes"
    let tabs = ["Quizzes", "Questions"]

    @State private var selectedQuestion: Question? = nil
    @State private var selectedQuiz: Quiz? = nil
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            SavedHeaderView(selectedTab: $selectedTab, tabs: tabs)
            
            Divider()
                .padding(.top, 16)
            
            VStack(spacing: 16) {
                ScrollView {
                    VStack(spacing: 12) {
                        if selectedTab == "Quizzes" {
                            ForEach(quizViewModel.savedQuizzes, id: \.id) { quiz in
                                SavedItemCard(title: quiz.topic) {
                                    selectedQuiz = quiz
                                }
                            }
                        } else {
                            ForEach(questionViewModel.savedQuestions, id: \.id) { question in
                                SavedItemCard(title: question.text) {
                                    selectedQuestion = question
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                }
            }
            .background(isDarkMode ? Color(.systemGray6) : nil)
        }
        .onAppear {
            quizViewModel.fetchQuizzes(from: context)
            questionViewModel.fetchQuestions(from: context)
        }
        .sheet(item: $selectedQuestion) { question in
            QuestionReviewView(
                question: question,
                viewModel: questionViewModel
            )
        }
        .sheet(item: $selectedQuiz) { quiz in
            QuizReviewView(
                quiz: quiz,
                viewModel: quizViewModel
            )
        }
    }
}

private struct SavedHeaderView: View {
    @Binding var selectedTab: String
    let tabs: [String]

    var body: some View {
        VStack(spacing: 12) {
            Text("label_saved")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top, 16)

            Picker("picker_select", selection: $selectedTab) {
                ForEach(tabs, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 24)
        }
    }
}

private struct SavedItemCard: View {
    let title: String
    var onTap: (() -> Void)? = nil
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var trimmedTitle: String {
        if title.count > 70 {
            return String(title.prefix(70)) + "..."
        } else {
            return title
        }
    }

    var body: some View {
        HStack {
            Text(trimmedTitle)
                .foregroundColor(.primary)
                .fontWeight(.medium)
            Spacer()
        }
        .padding()
        .background(isDarkMode ? Color(.systemGray5) : Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 1)
        .onTapGesture {
            onTap?()
        }
    }
}
