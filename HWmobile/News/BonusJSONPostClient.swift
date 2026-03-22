import Foundation

/// Дополнительный запрос с JSON-телом и заголовками (+1 балл): jsonplaceholder.typicode.com
enum BonusJSONPostClient {
    struct CreatePostBody: Encodable {
        let title: String
        let body: String
        let userId: Int
    }

    nonisolated static func sendSamplePost() async {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("HWmobile-bonus/1.0", forHTTPHeaderField: "X-Client-Info")
        let payload = CreatePostBody(title: "News app ping", body: "Bonus POST from homework", userId: 1)
        do {
            request.httpBody = try JSONEncoder().encode(payload)
            let (data, response) = try await URLSession.shared.data(for: request)
            let status = (response as? HTTPURLResponse)?.statusCode ?? -1
            let snippet: String
            if let text = String(data: data, encoding: .utf8) {
                let maxLen = min(text.count, 400)
                snippet = String(text.prefix(maxLen))
            } else {
                snippet = "<binary \(data.count) bytes>"
            }
            print("[BonusJSONPostClient] status=\(status) body=\(snippet)")
        } catch {
            print("[BonusJSONPostClient] error=\(error.localizedDescription)")
        }
    }
}
