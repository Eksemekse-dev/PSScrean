import SwiftUI

struct ContentView: View {
    @StateObject private var manager = ConsoleManager()
    @State private var showingAddModal = false
    
    var body: some View {
        NavigationView {
            List {
                if manager.consoles.isEmpty {
                    ContentUnavailableView(
                        "Brak połączonych PS4",
                        systemImage: "gamecontroller",
                        description: Text("Naciśnij +, aby dodać swoją pierwszą konsolę.")
                    )
                } else {
                    ForEach(manager.consoles) { console in
                        NavigationLink(destination: StreamView(console: console)) {
                            HStack {
                                Image(systemName: "playstation.house")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                VStack(alignment: .leading) {
                                    Text(console.profileName)
                                        .font(.headline)
                                    Text("PSN: \(console.psnOnlineId) | IP: \(console.ipAddress)")
                                        .font(.subcaption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .onDelete(perform: manager.deleteConsole)
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