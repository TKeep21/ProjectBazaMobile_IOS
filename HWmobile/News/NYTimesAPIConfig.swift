import Foundation

enum NYTimesAPIConfig {
    private static let embeddedKey = "zVIHW7MsLeCjveCuWsuCGzSnVT1AaN55bJRaTayNFXhtOCoK"

    static func resolvedAPIKey() -> String? {
        if let env = ProcessInfo.processInfo.environment["NYTIMES_API_KEY"] {
            let trimmed = env.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty {
                return trimmed
            }
        }
        let trimmed = embeddedKey.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
