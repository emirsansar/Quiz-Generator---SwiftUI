import Foundation

enum Secrets {
    static var geminiAPIKey: String {
        guard let apiKey = Bundle.main.infoDictionary?["GEMINI_API_KEY"] as? String else {
            fatalError("GEMINI_API_KEY not found.")
        }
        
        return apiKey
    }
}
