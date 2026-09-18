import Foundation
import Network

class NetworkDiscovery: ObservableObject {
    @Published var discoveredConsoles: [DiscoveredConsole] = []
    @Published var isScanning = false
    
    private var listener: NWListener?
    
    func startDiscovery() {
        isScanning = true
        discoveredConsoles.removeAll()
        
        // Domyślny port wyszukiwania PS4 w sieci lokalnej (UDP 987)
        let packet = "SRCH * HTTP/1.1\r\ndevice-discovery-protocol-version:0002000\r\n\r\n"
        guard let data = packet.data(using: .utf8) else { return }
        
        let host = NWEndpoint.Host("255.255.255.255")
        let port = NWEndpoint.Port(integerLiteral: 987)
        
        let connection = NWConnection(host: host, port: port, using: .udp)
        connection.start(queue: .global())
        
        connection.send(content: data, completion: .contentProcessed({ error in
            if let error = error {
                print("Błąd wysyłania pakietu discovery: \(error)")
            }
        }))
        
        // Wyłączanie skanowania po 5 sekundach
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.isScanning = false
        }
    }
}