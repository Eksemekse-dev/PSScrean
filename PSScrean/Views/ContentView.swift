import SwiftUI

// MARK: - Model Konsoli
struct PS4Console: Identifiable, Codable {
    var id = UUID()
    var profileName: String  // Nazwa lokalna (np. "Pokój")
    var psnOnlineId: String  // Nick PSN
    var pinCode: String      // Kod z PS4
    var ipAddress: String    // IP w sieci domowej
    var isAutoConnect: Bool  // Automatyczne łączenie
}

// MARK: - Zapis i Zarządzanie Konsolami
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

// MARK: - Główny Ekran (Lista Konsol + Menu)
struct ContentView: View {
    @StateObject private var manager = ConsoleManager()
    @State private var showingAddModal = false
    
    var body: some View {
        NavigationView {
            List {
                if manager.consoles.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "gamecontroller")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("Brak zapisanych konsol PS4")
                            .font(.headline)
                        Text("Naciśnij plusik w prawym górnym rogu, aby dodać konsolę.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                } else {
                    Section(header: Text("Twoje Konsole PS4")) {
                        ForEach(manager.consoles) { console in
                            NavigationLink(destination: ConnectionDetailsView(console: console)) {
                                HStack(spacing: 15) {
                                    Image(systemName: "playstation.house.fill")
                                        .font(.title)
                                        .foregroundColor(.blue)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(console.profileName)
                                            .font(.headline)
                                        Text("PSN: \(console.psnOnlineId)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Text("IP: \(console.ipAddress)")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .onDelete(perform: manager.deleteConsole)
                    }
                }
            }
            .navigationTitle("PSScrean")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddModal = true }) {
                        Image(systemName: "plus")
                            .font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showingAddModal) {
                AddConsoleView(manager: manager)
            }
        }
    }
}

// MARK: - Formularz Dodawania Nowej Konsoli
struct AddConsoleView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var manager: ConsoleManager
    
    @State private var profileName = ""
    @State private var psnOnlineId = ""
    @State private var pinCode = ""
    @State private var ipAddress = ""
    @State private var isAutoConnect = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profil konsoli")) {
                    TextField("Nazwa konsoli (np. Salon)", text: $profileName)
                    TextField("Nick PSN ID", text: $psnOnlineId)
                        .autocapitalization(.none)
                }
                
                Section(header: Text("Dane Połączenia PS4")) {
                    TextField("Kod PIN z PS4 (8 cyfr)", text: $pinCode)
                        .keyboardType(.numberPad)
                    TextField("Adres IP PS4 (np. 192.168.1.50)", text: $ipAddress)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Ustawienia")) {
                    Toggle("Łącz automatycznie przy starcie", isOn: $isAutoConnect)
                }
            }
            .navigationTitle("Dodaj nową PS4")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Anuluj") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Zapisz") {
                        let newConsole = PS4Console(
                            profileName: profileName,
                            psnOnlineId: psnOnlineId,
                            pinCode: pinCode,
                            ipAddress: ipAddress,
                            isAutoConnect: isAutoConnect
                        )
                        manager.addConsole(newConsole)
                        dismiss()
                    }
                    .disabled(profileName.isEmpty || pinCode.isEmpty || ipAddress.isEmpty)
                }
            }
        }
    }
}

// MARK: - Opcje Połączenia Konsoli (Po kliknięciu w konsolę)
struct ConnectionDetailsView: View {
    let console: PS4Console
    @State private var resolution = "1080p"
    @State private var fps = "60 FPS"
    
    var body: some View {
        Form {
            Section(header: Text("Informacje o urządzeniu")) {
                HStack {
                    Text("Nazwa")
                    Spacer()
                    Text(console.profileName).foregroundColor(.gray)
                }
                HStack {
                    Text("PSN Online ID")
                    Spacer()
                    Text(console.psnOnlineId).foregroundColor(.gray)
                }
                HStack {
                    Text("Adres IP")
                    Spacer()
                    Text(console.ipAddress).foregroundColor(.gray)
                }
                HStack {
                    Text("Kod PIN")
                    Spacer()
                    Text(console.pinCode).foregroundColor(.gray)
                }
            }
            
            Section(header: Text("Ustawienia Strumieniowania")) {
                Picker("Jakość obrazu", selection: $resolution) {
                    Text("720p").tag("720p")
                    Text("1080p").tag("1080p")
                }
                Picker("Płynność (FPS)", selection: $fps) {
                    Text("30 FPS").tag("30 FPS")
                    Text("60 FPS").tag("60 FPS")
                }
            }
            
            Section {
                Button(action: {
                    // Miejsce na uruchomienie streamu w przyszłości
                }) {
                    HStack {
                        Spacer()
                        Label("Połącz z PS4", systemImage: "play.circle.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(Color.blue)
            }
        }
        .navigationTitle(console.profileName)
    }
}
