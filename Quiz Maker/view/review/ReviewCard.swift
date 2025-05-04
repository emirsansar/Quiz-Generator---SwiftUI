import SwiftUI

struct ReviewCard: View {
    let question: Question
    let showAnswers: Bool
    @State var selectedAnswer: String?
    let onAnswerSelected: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("❓ \(question.text)")
                .font(.title3)

            ForEach(question.choices, id: \.self) { choice in
                AnswerOptionView(
                    text: choice,
                    isCorrect: choice == question.answer,
                    isSelected: choice == selectedAnswer,
                    showAnswers: showAnswers,
                    onSelected: { answer in
                        selectedAnswer = answer
                    }
                )
            }

            if showAnswers {
                HStack {
                    AnswerResultText(
                        selectedAnswer: selectedAnswer,
                        correctAnswer: question.answer
                    )

                    Spacer()
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
