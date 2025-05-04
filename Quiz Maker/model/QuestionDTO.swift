import Foundation

// DTO used to decode question data and convert it to a SwiftData model.
struct QuestionDTO: Codable, Identifiable {
    var id: UUID
    let text: String
    let choices: [String]
    let answer: String
    let createdAt: Date

    func toModel() -> Question {
        return Question(
            id: id,
            text: text,
            choices: choices,
            answer: answer,
            createdAt: createdAt
        )
    }
}
