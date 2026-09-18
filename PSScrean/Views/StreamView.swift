import SwiftUI

struct StreamView: View {
    let console: PS4Console
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Łączenie z \(console.profileName)...")
                    .foregroundColor(.white)
                    .font(.headline)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                
                Text("IP: \(console.ipAddress) | PIN: \(console.pinCode)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle(console.profileName)
        .navigationBarTitleDisplayMode(.inline)
    }
}