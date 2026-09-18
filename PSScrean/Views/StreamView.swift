import SwiftUI

struct StreamView: View {
    let console: PS4Console
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("PS4 Stream: \(console.profileName)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                // Wirtualny pad nakładany na obraz
                VirtualControllerView()
                    .padding(.bottom, 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}