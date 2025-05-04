import SwiftUI
import SwiftData

struct QuizView: View {
    let questions: [Question]
    let topic: String

    @State private var currentIndex: Int = 0
    @State private var selectedAnswer: String? = nil
    @State private var showResult: Bool = false
    @State private var correctCount: Int = 0
    @State private var isCompleted: Bool = false

    var body: some View {
        if !isCompleted {
            QuizContainer(
                questions: questions,
                currentIndex: $currentIndex,
                selectedAnswer: $selectedAnswer,
                showResult: $showResult,
                correctCount: $correctCount,
                isCompleted: $isCompleted
            )
        } else {
            QuizCompletedView(
                correct: correctCount,
                total: questions.count,
                questions: questions,
                topic: topic
            )
        }
    }
}

private struct QuizContainer: View {
    let questions: [Question]
    @Binding var currentIndex: Int
    @Binding var selectedAnswer: String?
    @Binding var showResult: Bool
    @Binding var correctCount: Int
    @Binding var isCompleted: Bool
    
    @State private var showToast = false
    
    @Environment(\.modelContext) private var context
    @State private var viewModel = QuestionViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ProgressBar(current: currentIndex + 1, total: questions.count)
                
                QuestionCard(
                    question: questions[currentIndex],
                    showAnswers: showResult,
                    selectedAnswer: selectedAnswer,
                    onAnswerSelected: { answer in
                        selectedAnswer = answer
                    },
                    onSave: {
                        let currentQuestion = questions[currentIndex]
                        viewModel.save(question: currentQuestion, in: context)
                    },
                    onRemove: {
                        let currentQuestion = questions[currentIndex]
                        viewModel.delete(by: currentQuestion.id, in: context)
                    }
                )
                
                Spacer()
            }
            .padding()
        }
        
        QuizActionButton(
            selectedAnswer: selectedAnswer,
            showResult: showResult,
            isLastQuestion: currentIndex == questions.count - 1,
            isCorrect: selectedAnswer == questions[currentIndex].answer,
            onNext: {
                if currentIndex < questions.count - 1 {
                    currentIndex += 1
                    selectedAnswer = nil
                    showResult = false
                }
            },
            onFinish: {
                isCompleted = true
            },
            onCheck: {
                showResult = true
            }
        )
        .padding(.horizontal)
    }
        
}

private struct ProgressBar: View {
    let current: Int
    let total: Int

    var body: some View {
        VStack {
            Text("\(current) / \(total)")
                .font(.caption)
                .foregroundColor(.secondary)

            ProgressView(value: Float(current), total: Float(total))
                .accentColor(.blue)
        }
        .padding(.bottom, 8)
        .padding(.horizontal)
    }
}

private struct QuizActionButton: View {
    let selectedAnswer: String?
    let showResult: Bool
    let isLastQuestion: Bool
    let isCorrect: Bool
    let onNext: () -> Void
    let onFinish: () -> Void
    let onCheck: () -> Void

    var buttonText: String {
        if !showResult {
            return "btn_check_answer"
        } else if isLastQuestion {
            return "btn_show_result"
        } else {
            return "btn_next_question"
        }
    }
    
    var body: some View {
        Button(action: {
            if showResult {
                if isCorrect {
                    onNext()
                }
                
                if isLastQuestion {
                    onFinish()
                } else {
                    onNext()
                }
            } else {
                onCheck()
            }
        }) {
            Text(LocalizedStringKey(buttonText))
                .frame(maxWidth: .infinity)
                .padding()
                .background(selectedAnswer == nil && !showResult ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .disabled(selectedAnswer == nil && !showResult)
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
}
