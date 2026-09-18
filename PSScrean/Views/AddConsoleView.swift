import SwiftUI

struct AddConsoleView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var manager: ConsoleManager
    
    @State private var profileName = ""
    @State private var psnOnlineId = ""
    @State private var pinCode = ""
    @State private var ipAddress = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Dane użytkownika")) {
                    TextField("Nick w aplikacji (np. Pokój)", text: $profileName)
                    TextField("Nick PSN ID", text: $psnOnlineId)
                        .autocapitalization(.none)
                }
                
                Section(header: Text("Połączenie z PS4")) {
                    TextField("Kod PIN z PS4 (8 cyfr)", text: $pinCode)
                        .keyboardType(.numberPad)
                    TextField("Adres IP PS4 (np. 192.168.1.50)", text: $ipAddress)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Dodaj PS4")
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
                            ipAddress: ipAddress
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