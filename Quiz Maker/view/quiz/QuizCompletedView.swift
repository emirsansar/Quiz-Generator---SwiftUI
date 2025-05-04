import SwiftUI

struct QuizCompletedView: View {
    let correct: Int
    let total: Int
    let questions: [Question]
    let topic: String
    
    @Environment(\.modelContext) private var context
    @State private var viewModel = QuizViewModel()

    var body: some View {
        VStack(spacing: 16) {
            Text("label_quiz_completed")
                .font(.title)
                .bold()

            Text("text_correct_answers: \(correct) / \(total)")
                .font(.headline)
                .foregroundColor(.secondary)

            SaveQuizButton(
                onSave: {
                    let newQuiz = Quiz(topic: topic, questions: questions)
                    viewModel.save(quiz: newQuiz, in: context)
                },
                onRemove: {
                    viewModel.deleteLatest(in: context)
                }
            )
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

import SwiftUI

struct SaveQuizButton: View {
    @State private var isSaved = false

    var onSave: () -> Void
    var onRemove: () -> Void

    var body: some View {
        Button(action: {
            withAnimation {
                isSaved.toggle()
            }

            isSaved ? onSave() : onRemove()
        }) {
            Text(isSaved ? "text_saved" : "btn_save_quiz")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isSaved ? Color.green : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal, 70)
                .padding(.top, 16)
        }
    }
}
