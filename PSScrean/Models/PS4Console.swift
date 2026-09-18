import Foundation

struct PS4Console: Identifiable, Codable {
    var id = UUID()
    var profileName: String
    var psnOnlineId: String
    var pinCode: String
    var ipAddress: String
}