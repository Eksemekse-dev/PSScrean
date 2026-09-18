import SwiftUI

struct ContentView: View {
    @StateObject private var manager = ConsoleManager()
    @StateObject private var discovery = NetworkDiscovery()
    @State private var showingAddModal = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Automatyczne wyszukiwanie Wi-Fi")) {
                    Button(action: { discovery.startDiscovery() }) {
                        HStack {
                            Image(systemName: "wifi")
                            Text(discovery.isScanning ? "Skanowanie sieci..." : "Szukaj PS4 w sieci Wi-Fi")
                            if discovery.isScanning {
                                Spacer()
                                ProgressView()
                            }
                        }
                    }
                }
                
                Section(header: Text("Zapisane Konsole")) {
                    if manager.consoles.isEmpty {
                        Text("Brak zapisanych konsol. Kliknij +, aby dodać.")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    } else {
                        ForEach(manager.consoles) { console in
                            NavigationLink(destination: StreamView(console: console)) {
                                HStack {
                                    Image(systemName: "playstation.house.fill")
                                        .foregroundColor(.blue)
                                    VStack(alignment: .leading) {
                                        Text(console.profileName).font(.headline)
                                        Text("IP: \(console.ipAddress)").font(.caption).foregroundColor(.gray)
                                    }
                                }
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
                    }
                }
            }
            .sheet(isPresented: $showingAddModal) {
                AddConsoleView(manager: manager)
            }
        }
    }
}