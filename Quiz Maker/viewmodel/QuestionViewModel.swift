import Foundation
import SwiftData
import Observation

@Observable
class QuestionViewModel {
    private(set) var savedQuestions: [Question] = []
    
    // Fetch all saved questions, sorted by newest first.
    func fetchQuestions(from context: ModelContext) {
        let descriptor = FetchDescriptor<Question>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        do {
            savedQuestions = try context.fetch(descriptor)
        } catch {
            print("Failed to fetch question list: \(error)")
        }
    }
    
    // Save a new question and refresh the list.
    func save(question: Question, in context: ModelContext) {
        context.insert(question)
        fetchQuestions(from: context)
        print("Question saved: \(question.text)")
    }

    // Delete a question and refresh the list.
    func delete(question: Question, in context: ModelContext) {
        context.delete(question)
        fetchQuestions(from: context)
        print("Question deleted: \(question.text)")
    }
    
    // Delete question by its UUID.
    func delete(by id: UUID, in context: ModelContext) {
        let descriptor = FetchDescriptor<Question>(
            predicate: #Predicate { $0.id == id }
        )
        
        if let found = try? context.fetch(descriptor).first {
            context.delete(found)
            fetchQuestions(from: context)
            print("Question deleted by UUID: \(found.text)")
        } else {
            print("No question found matching the UUID.")
        }
    }

    // Delete all saved questions.
    func deleteAll(in context: ModelContext) {
        let descriptor = FetchDescriptor<Question>()
        
        do {
            let allQuestions = try context.fetch(descriptor)
            for question in allQuestions {
                context.delete(question)
            }
            fetchQuestions(from: context)
            print("All questions deleted. (\(allQuestions.count) total)")
        } catch {
            print("Error while deleting questions: \(error.localizedDescription)")
        }
    }
}
