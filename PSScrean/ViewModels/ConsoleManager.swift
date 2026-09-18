import Foundation

class ConsoleManager: ObservableObject {
    @Published var consoles: [PS4Console] = [] {
        didSet { saveConsoles() }
    }
    
    private let saveKey = "SavedPS4Consoles"
    
    init() { loadConsoles() }
    
    func addConsole(_ console: PS4Console) {
        consoles.append(console)
    }
    
    func deleteConsole(at offsets: IndexSet) {
        consoles.remove(atOffsets: offsets)
    }
    
    private func saveConsoles() {
        if let encoded = try? JSONEncoder().encode(consoles) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadConsoles() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([PS4Console].self, from: data) {
            consoles = decoded
        }
    }
}