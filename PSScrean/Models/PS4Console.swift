import Foundation

struct PS4Console: Identifiable, Codable {
    var id = UUID()
    var profileName: String
    var psnOnlineId: String
    var pinCode: String
    var ipAddress: String
    var isAutoConnect: Bool = false
}

struct DiscoveredConsole: Identifiable {
    var id = UUID()
    var hostName: String
    var ipAddress: String
    var status: String
}