import Foundation

struct Note: Identifiable, Codable {
    var id = UUID()
    var title: String
    var content: String
    var date: Date
    var noteURL: URL
    var noteFolder: URL
}