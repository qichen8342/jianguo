import SwiftUI

@main
struct AppleNotesApp: App {
    @StateObject private var store = NoteStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .frame(minWidth: 800, minHeight: 500)
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified)
        .commands {
            CommandGroup(after: .newItem) {
                Button("新建笔记") {
                    store.createNote()
                }
                .keyboardShortcut("n", modifiers: .command)
            }
            CommandGroup(replacing: .pasteboard) {
                Button("删除笔记") {
                    if let id = store.selectedNoteID {
                        store.deleteNote(id: id)
                    }
                }
                .keyboardShortcut(.delete, modifiers: .command)
            }
        }
    }
}
