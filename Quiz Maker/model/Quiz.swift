import SwiftData
import Foundation

@Model
class Quiz {
    @Attribute(.unique) var id: UUID
    var topic: String
    var questions: [Question]
    var createdAt: Date

    init(topic: String, questions: [Question], createdAt: Date = Date()) {
        self.id = UUID()
        self.topic = topic
        self.questions = questions
        self.createdAt = createdAt
    }
}
