import SwiftUI

struct Cell: View {
    var isBlack: Bool
    var action: () -> Void

    var body: some View {
        Rectangle()
            .fill(isBlack ? Color.black : Color.white)
            .aspectRatio(1, contentMode: .fit) // Ensures the cell remains square
            .border(Color.gray, width: 1)
            .onTapGesture(perform: action)
    }
}