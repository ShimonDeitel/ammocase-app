import Foundation

struct LotItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var caliber: String
    var quantity: String
    var notes: String = ""
    var dateAdded: Date = Date()
}
