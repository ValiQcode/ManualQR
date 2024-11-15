//
//  ContentView.swift
//  ManualQR
//
//  Created by Bastiaan Quast on 11/14/24.
//

import SwiftUI
import CoreData

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
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \QRCodeDocument.timestamp, ascending: false)],
        animation: .default)
    private var documents: FetchedResults<QRCodeDocument>
    
    @State private var grid: [[Bool]] = Array(repeating: Array(repeating: false, count: 11), count: 11)
    @State private var showingSidebar = true

    var body: some View {
        NavigationView {
            if showingSidebar {
                SidebarView(documents: documents, loadDocument: loadDocument)
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
                        createNewDocument()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    private func toggleCell(row: Int, column: Int) {
        grid[row][column].toggle()
    }

    private func createNewDocument() {
        let newDocument = QRCodeDocument(context: viewContext)
        newDocument.timestamp = Date()
        newDocument.gridData = encodeGrid(grid)
        
        do {
            try viewContext.save()
        } catch {
            // Handle errors as appropriate
        }
    }

    private func loadDocument(document: QRCodeDocument) {
        if let gridData = document.gridData {
            grid = decodeGrid(gridData)
        }
    }

    private func encodeGrid(_ grid: [[Bool]]) -> Data {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: grid, options: [])
            return jsonData
        } catch {
            fatalError("Failed to encode grid data: \(error)")
        }
    }

    private func decodeGrid(_ data: Data) -> [[Bool]] {
        do {
            if let array = try JSONSerialization.jsonObject(with: data, options: []) as? [[Bool]] {
                return array
            } else {
                fatalError("Failed to decode grid data")
            }
        } catch {
            fatalError("Failed to decode grid data: \(error)")
        }
    }
}

struct SidebarView: View {
    var documents: FetchedResults<QRCodeDocument>
    var loadDocument: (QRCodeDocument) -> Void
    
    var body: some View {
        List(documents) { document in
            Button(action: {
                loadDocument(document)
            }) {
                Text("\(document.timestamp ?? Date(), formatter: itemFormatter)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

@main
struct QRCodeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
