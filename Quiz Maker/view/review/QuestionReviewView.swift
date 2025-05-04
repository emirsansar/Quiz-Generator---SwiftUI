import SwiftUI
import SwiftData

struct QuestionReviewView: View {
    let question: Question
    @Bindable var viewModel: QuestionViewModel

    @Environment(\.modelContext) private var context
    @State private var selectedAnswer: String? = nil
    @State private var showAnswer: Bool = false
    @State private var isDeleted = false
    @State private var showMenu = false

    var body: some View {
        VStack {
            TopBarForReviews(title: "label_question_review", showMenu: $showMenu)
                .confirmationDialog("options", isPresented: $showMenu, titleVisibility: .hidden) {
                    Button(showAnswer ? "btn_hide_answer" : "btn_show_answer") {
                        showAnswer.toggle()
                    }

                    if isDeleted {
                        Button("btn_save_again") {
                            viewModel.save(question: question, in: context)
                            isDeleted.toggle()
                        }
                    } else {
                        Button("btn_delete_question", role: .destructive) {
                            viewModel.delete(by: question.id, in: context)
                            isDeleted.toggle()
                        }
                    }

                    Button("btn_cancel", role: .cancel) {}
                }
            
            Divider()
            
            ScrollView {
                VStack {
                    ReviewCard(
                        question: question,
                        showAnswers: showAnswer,
                        selectedAnswer: selectedAnswer,
                        onAnswerSelected: { answer in
                            selectedAnswer = answer
                        }
                    )
                    .padding(.horizontal, 5)
                }
                .padding()
            }
        }
    }
}
