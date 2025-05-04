import Foundation
import SwiftData
import Observation

@Observable
class QuizViewModel {
    private(set) var savedQuizzes: [Quiz] = []

    // Fetch all saved quizzes, sorted by newest first.
    func fetchQuizzes(from context: ModelContext) {
        let descriptor = FetchDescriptor<Quiz>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        do {
            savedQuizzes = try context.fetch(descriptor)
        } catch {
            print("Failed to fetch quiz list: \(error)")
        }
    }

    // Save a new quiz and refresh the list.
    func save(quiz: Quiz, in context: ModelContext) {
        context.insert(quiz)
        fetchQuizzes(from: context)
        print("Quiz saved: \(quiz.topic)")
    }

    // Delete a quiz and refresh the list.
    func delete(quiz: Quiz, in context: ModelContext) {
        context.delete(quiz)
        fetchQuizzes(from: context)
        print("Quiz deleted: \(quiz.topic)")
    }

    // Delete a quiz by its UUID.
    func delete(by id: UUID, in context: ModelContext) {
        let descriptor = FetchDescriptor<Quiz>(
            predicate: #Predicate { $0.id == id }
        )

        if let found = try? context.fetch(descriptor).first {
            context.delete(found)
            fetchQuizzes(from: context)
            print("Quiz deleted by UUID: \(found.topic)")
        } else {
            print("No quiz found matching the UUID.")
        }
    }

    // Delete the most recently created quiz.
    func deleteLatest(in context: ModelContext) {
        let descriptor = FetchDescriptor<Quiz>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        do {
            if let latestQuiz = try context.fetch(descriptor).first {
                context.delete(latestQuiz)
                fetchQuizzes(from: context)
                print("Most recently added quiz deleted: \(latestQuiz.topic)")
            } else {
                print("No quiz found to delete.")
            }
        } catch {
            print("Failed to delete the latest quiz: \(error.localizedDescription)")
        }
    }

    // Delete all saved quizzes.
    func deleteAll(in context: ModelContext) {
        let descriptor = FetchDescriptor<Quiz>()

        do {
            let allQuizzes = try context.fetch(descriptor)
            for quiz in allQuizzes {
                context.delete(quiz)
            }
            fetchQuizzes(from: context)
            print("All quizzes deleted. (\(allQuizzes.count) total)")
        } catch {
            print("Error occurred while deleting quizzes: \(error.localizedDescription)")
        }
    }
}
