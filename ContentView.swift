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
            .aspectRatio(1, contentMode: .fit)
            .border(Color.gray.opacity(1), width: 0)
            .onTapGesture(perform: action)
    }
}

struct ContentView: View {
    @State private var grid: [[Bool]] = Array(repeating: Array(repeating: false, count: 11), count: 11)
    @State private var showingSidebar = true

    var body: some View {
        NavigationView {
            if showingSidebar {
                SidebarView()
            }
            
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
            .background(Color.gray.opacity(0))
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        self.showingSidebar.toggle()
                    }) {
                        Image(systemName: "sidebar.leading")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        // Action for creating a new document
                        self.createNewDocument()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    func toggleCell(row: Int, column: Int) {
        grid[row][column].toggle()
    }
    
    func createNewDocument() {
        // Logic to create a new QR code document
        grid = Array(repeating: Array(repeating: false, count: 11), count: 11)
    }
}

struct SidebarView: View {
    var body: some View {
        Text("Document History")
            .frame(width: 200)
    }
}

@main
struct QRCodeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
