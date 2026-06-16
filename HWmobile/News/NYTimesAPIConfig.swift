import Foundation

enum NYTimesAPIConfig {
    private static let embeddedKey = ""

    static func resolvedAPIKey() -> String? {
        if let env = ProcessInfo.processInfo.environment["NYTIMES_API_KEY"] {
            return normalize(env)
        }
        if let plist = Bundle.main.object(forInfoDictionaryKey: "NYTIMES_API_KEY") as? String {
            return normalize(plist)
        }
        if let bundledSecret = bundledSecretsAPIKey() {
            return bundledSecret
        }
        return normalize(embeddedKey)
    }

    private static func normalize(_ raw: String) -> String? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private static func bundledSecretsAPIKey() -> String? {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let object = try? PropertyListSerialization.propertyList(from: data, format: nil),
              let dictionary = object as? [String: Any],
              let key = dictionary["NYTIMES_API_KEY"] as? String else {
            return nil
        }
        return normalize(key)
    }
}
