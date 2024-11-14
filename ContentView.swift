//
//  ContentView.swift
//  ManualQR
//
//  Created by Bastiaan Quast on 11/14/24.
//

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

struct ContentView: View {
    @State private var grid: [[Bool]] = Array(repeating: Array(repeating: false, count: 11), count: 11)

    var body: some View {
        VStack {
            ForEach(0..<11, id: \.self) { row in
                HStack {
                    ForEach(0..<11, id: \.self) { column in
                        Cell(isBlack: self.grid[row][column]) {
                            self.toggleCell(row: row, column: column)
                        }
                    }
                }
            }
        }
    }
    
    func toggleCell(row: Int, column: Int) {
        grid[row][column].toggle()
    }
}
