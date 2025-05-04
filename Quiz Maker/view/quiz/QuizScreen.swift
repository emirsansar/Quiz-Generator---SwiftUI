import SwiftUI

struct QuizScreen: View {
    let topic: String
    let difficulty: String
    let testType: String
    let language: String
    let count: String
    
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    @State private var questions: [QuestionDTO] = []

    var body: some View {
        Group {
            if isLoading {
                ProgressView("text_quiz_creating")
            } else if let error = errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text("text_an_error_occured")
                    Text(error)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            } else {
                QuizView(
                    questions: questions.map { $0.toModel() },
                    topic: topic
                )
            }
        }
        .navigationTitle("Quiz")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task { await loadQuiz() }
        }
    }

    private func loadQuiz() async {
        do {
            let service = GeminiService()
            let result = await service.getGeminiAIQuestions(
                topic: topic,
                difficulty: difficulty,
                testType: testType,
                language: language,
                count: count
            )

            if !result.success {
                errorMessage = result.error ?? "text_unknown_error"
            } else {
                questions = result.questions
                errorMessage = nil
            }

            isLoading = false
        } catch {
            errorMessage = "text_unexpected_error: \(error.localizedDescription)"
            isLoading = false
        }
    }
}
