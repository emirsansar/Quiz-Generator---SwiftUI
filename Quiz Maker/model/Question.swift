import SwiftData
import Foundation

@Model
class Question {
    @Attribute(.unique) var id: UUID
    var text: String
    var choices: [String]
    var answer: String
    var createdAt: Date

    init(id: UUID = UUID(), text: String, choices: [String], answer: String, createdAt: Date = Date()) {
        self.id = id
        self.text = text
        self.choices = choices
        self.answer = answer
        self.createdAt = createdAt
    }
}
