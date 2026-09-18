import SwiftUI

struct VirtualControllerView: View {
    var body: some View {
        HStack {
            // D-PAD / Left Stick
            VStack {
                Button(action: {}) { Image(systemName: "chevron.up.circle.fill").font(.system(size: 45)) }
                HStack(spacing: 20) {
                    Button(action: {}) { Image(systemName: "chevron.left.circle.fill").font(.system(size: 45)) }
                    Button(action: {}) { Image(systemName: "chevron.right.circle.fill").font(.system(size: 45)) }
                }
                Button(action: {}) { Image(systemName: "chevron.down.circle.fill").font(.system(size: 45)) }
            }
            .foregroundColor(.white.opacity(0.8))
            
            Spacer()
            
            // Action Buttons (Triangle, Circle, Cross, Square)
            VStack {
                Button(action: {}) { Image(systemName: "triangle.circle.fill").font(.system(size: 45)).foregroundColor(.green) }
                HStack(spacing: 20) {
                    Button(action: {}) { Image(systemName: "square.circle.fill").font(.system(size: 45)).foregroundColor(.pink) }
                    Button(action: {}) { Image(systemName: "circle.circle.fill").font(.system(size: 45)).foregroundColor(.red) }
                }
                Button(action: {}) { Image(systemName: "multiply.circle.fill").font(.system(size: 45)).foregroundColor(.blue) }
            }
        }
        .padding(.horizontal, 30)
    }
}