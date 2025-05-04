import SwiftUI
import SwiftData

struct QuizReviewView: View {
    let quiz: Quiz
    @Bindable var viewModel: QuizViewModel
    
    @Environment(\.modelContext) private var context
    @State private var expandedIndex: Int? = nil
    @State private var isDeleted = false
    @State private var showAnswers: Bool = false
    @State private var isExpanded: Bool = false
    @State private var showMenu = false
    
    @State private var selectedAnswers: [UUID: String] = [:]

    var body: some View {
        VStack {
            TopBarForReviews(title: "label_quiz_review", showMenu: $showMenu)
                .confirmationDialog("options", isPresented: $showMenu, titleVisibility: .hidden) {
                    Button(showAnswers ? "btn_hide_answers" : "btn_show_answers") {
                        showAnswers.toggle()
                    }

                    Button(isExpanded ? "btn_collapse_questions" : "btn_expand_questions") {
                        isExpanded.toggle()
                    }

                    if isDeleted {
                        Button("btn_save_again") {
                            viewModel.save(quiz: quiz, in: context)
                            isDeleted.toggle()
                        }
                    } else {
                        Button("btn_delete_quiz", role: .destructive) {
                            viewModel.delete(by: quiz.id, in: context)
                            isDeleted.toggle()
                        }
                    }

                    Button("btn_cancel", role: .cancel) {}
                }

            Divider()

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(Array(quiz.questions.enumerated()), id: \.offset) { index, question in
                        VStack(alignment: .leading, spacing: 8) {
                            Button(action: {
                                withAnimation {
                                    expandedIndex = expandedIndex == index ? nil : index
                                }
                            }) {
                                HStack {
                                    Text("\(index + 1). Question")
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: expandedIndex == index ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                            }

                            if expandedIndex == index || isExpanded {
                                ReviewCard(
                                    question: question,
                                    showAnswers: showAnswers,
                                    selectedAnswer: selectedAnswers[question.id] ?? (showAnswers ? question.answer : nil),
                                    onAnswerSelected: { answer in
                                        selectedAnswers[question.id] = answer
                                    }
                                )
                                .padding(.horizontal, 5)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
        }
    }
}
