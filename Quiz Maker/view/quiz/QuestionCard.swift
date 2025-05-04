import SwiftUI

struct QuestionCard: View {
    let question: Question
    let showAnswers: Bool
    let selectedAnswer: String?
    let onAnswerSelected: (String) -> Void
    let onSave: () -> Void
    let onRemove: () -> Void

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
                    onSelected: onAnswerSelected
                )
            }
            
            if showAnswers {
                HStack {
                    AnswerResultText(
                        selectedAnswer: selectedAnswer,
                        correctAnswer: question.answer
                    )

                    Spacer()

                    SaveQuestionButton(onSave: onSave, onRemove: onRemove)
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.horizontal)
    }
}

struct AnswerOptionView: View {
    let text: String
    let isCorrect: Bool
    let isSelected: Bool
    let showAnswers: Bool
    let onSelected: (String) -> Void

    var body: some View {
        let color: Color = {
            if showAnswers {
                if isSelected && isCorrect { return .green }
                if isSelected && !isCorrect { return .red }
                if !isSelected && isCorrect { return .green }
                return Color(.systemGray5)
            } else {
                return isSelected ? Color.blue : Color(.systemGray5)
            }
        }()

        let textColor: Color = (color == Color(.systemGray5)) ? .primary : .white

        Text(text)
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(color)
            .foregroundColor(textColor)
            .cornerRadius(8)
            .onTapGesture {
                if !showAnswers {
                    onSelected(text)
                }
            }
    }
}

struct AnswerResultText: View {
    let selectedAnswer: String?
    let correctAnswer: String

    var body: some View {
        let result: (textKey: LocalizedStringKey, color: Color) = {
            if selectedAnswer == nil {
                return ("text_no_answer", .gray)
            } else if selectedAnswer == correctAnswer {
                return ("text_correct", .green)
            } else {
                return ("text_wrong", .red)
            }
        }()

        Text(result.textKey)
            .foregroundColor(result.color)
            .fontWeight(.semibold)
            .padding(.top, 4)
            .padding(.leading, 8)
    }
}

struct SaveQuestionButton: View {
    let onSave: () -> Void
    let onRemove: () -> Void

    @State private var isSaved = false

    var body: some View {
        Button(action: {
            if isSaved {
                onRemove()
            } else {
                onSave()
            }
            isSaved.toggle()
        }) {
            Text(isSaved ? "text_saved" : "btn_save")
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .frame(height: 36)
                .background(isSaved ? Color.green.opacity(0.2) : .clear)
                .foregroundColor(isSaved ? .green : .blue)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSaved ? Color.green : Color.blue, lineWidth: 1)
                )
                .cornerRadius(8)
        }
    }
}

#Preview {
    QuestionCard(
        question: Question(
            id: UUID(),
            text: "2+2 = ?",
            choices: ["A) 1", "B) 2", "C) 3", "D) 4"],
            answer: "A) View"
        ),
        showAnswers: true,
        selectedAnswer: "B) 2",
        onAnswerSelected: { _ in },
        onSave: {},
        onRemove: {}
    )
}
