import Foundation

// Model for Gemini API response.
struct GeminiResult: Codable {
    let questions: [QuestionDTO]
    let success: Bool
    let error: String?
}

class GeminiService {

    func getGeminiAIQuestions(
        topic: String,
        difficulty: String,
        testType: String,
        language: String,
        count: String
    ) async -> GeminiResult {
        do {
            print("1. Preparing prompt...")
            let translatedQuizType = NSLocalizedString(testType, comment: "")
            
            let prompt = GeminiPrompt.getPrompt(
                topic: topic,
                difficulty: difficulty,
                testType: translatedQuizType,
                language: language,
                count: count
            )

            print("2. Building request body...")
            let requestBody: [String: Any] = [
                "contents": [
                    [
                        "role": "user",
                        "parts": [
                            ["text": prompt]
                        ]
                    ]
                ]
            ]

            let apiKey = Secrets.geminiAPIKey
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
            
            // Build request URL with API key.
            var urlComponents = URLComponents(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent")!
            urlComponents.queryItems = [URLQueryItem(name: "key", value: apiKey)]

            // Configure HTTP request.
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            print("3. Sending API request...")
            let (data, response) = try await URLSession.shared.data(for: request)

            // Check HTTP response code.
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Code: \(httpResponse.statusCode)")
                if !(200...299).contains(httpResponse.statusCode) {
                    return GeminiResult(questions: [], success: false, error: "API Error: \(response)")
                }
            }

            // Print raw response.
            let rawResponse = String(data: data, encoding: .utf8) ?? "n/a"
            print("4. Raw response:\n\(rawResponse)")

            print("5. Cleaning JSON...")
            let cleanedJson = try extractGeminiQuestions(from: data)
            print("6. Cleaned JSON:\n\(cleanedJson)")

            print("7. Parsing response...")
            let result = parseGeminiResponse(jsonString: cleanedJson)

            print("8. Quiz generation result: success=\(result.success), error=\(String(describing: result.error))")
            return result

        } catch {
            print("Unexpected error: \(error.localizedDescription)")
            return GeminiResult(questions: [], success: false, error: error.localizedDescription)
        }
    }

    // Extracts and cleans the raw Gemini API response.
    private func extractGeminiQuestions(from data: Data) throws -> String {
        let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard
            let candidates = jsonObject?["candidates"] as? [[String: Any]],
            let content = candidates.first?["content"] as? [String: Any],
            let parts = content["parts"] as? [[String: Any]],
            let text = parts.first?["text"] as? String,
            !text.isEmpty
        else {
            print("Invalid response structure!")
            throw NSError(domain: "GeminiParseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response structure"])
        }

        print("Extracted text:\n\(text)")

        // Remove Markdown formatting and escape characters.
        let cleaned = cleanJsonResponse(text)
        print("Cleaned JSON:\n\(cleaned)")

        // Validate that result is valid JSON.
        guard cleaned.trimmingCharacters(in: .whitespacesAndNewlines).first == "{" else {
            print("Cleaned content is not valid JSON!")
            throw NSError(domain: "GeminiParseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Cleaned response is not valid JSON"])
        }

        return cleaned
    }

    // Simple string cleanup to fix escaped or malformed JSON.
    private func cleanJsonResponse(_ content: String) -> String {
        return content
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .replacingOccurrences(of: "\\n", with: "\n")
            .replacingOccurrences(of: "\\\"", with: "\"")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // Parses cleaned JSON string into a GeminiResult model.
    private func parseGeminiResponse(jsonString: String) -> GeminiResult {
        guard let data = jsonString.data(using: .utf8) else {
            print("Failed to encode JSON string as UTF-8!")
            return GeminiResult(questions: [], success: false, error: "String encoding error")
        }

        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let success = (json?["success"] as? String) == "true"
            let error = json?["error"] as? String

            if !success {
                print("Gemini returned failure: \(error ?? "unknown")")
                return GeminiResult(questions: [], success: false, error: error)
            }

            // Parse array of questions.
            guard let questionsArray = json?["questions"] as? [[String: Any]] else {
                print("Missing questions[] field!")
                return GeminiResult(questions: [], success: false, error: "Questions not found")
            }

            // Map each question item to a DTO.
            let questions = questionsArray.enumerated().map { (_, item) -> QuestionDTO in
                let text = item["question"] as? String ?? ""
                let choices = item["options"] as? [String] ?? []
                let answer = item["correct_option"] as? String ?? ""
                return QuestionDTO(
                    id: UUID(),
                    text: text,
                    choices: choices,
                    answer: answer,
                    createdAt: Date()
                )
            }

            return GeminiResult(questions: questions, success: true, error: nil)

        } catch {
            print("JSON parse error: \(error.localizedDescription)")
            return GeminiResult(questions: [], success: false, error: "Parse error: \(error.localizedDescription)")
        }
    }
}
