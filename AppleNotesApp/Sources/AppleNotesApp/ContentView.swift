import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: NoteStore

    var body: some View {
        NavigationSplitView {
            NoteListView()
                .navigationSplitViewColumnWidth(min: 220, ideal: 260, max: 320)
        } detail: {
            if let binding = store.selectedNote {
                NoteEditorView(note: binding)
            } else {
                EmptyStateView()
            }
        }
    }
}

struct EmptyStateView: View {
    @EnvironmentObject var store: NoteStore

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "note.text.badge.plus")
                .font(.system(size: 64))
                .foregroundStyle(.tertiary)
            Text("没有选中的笔记")
                .font(.title3)
                .foregroundStyle(.secondary)
            Button("新建笔记") {
                store.createNote()
            }
            .buttonStyle(.borderedProminent)
            .keyboardShortcut("n", modifiers: .command)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.windowBackground)
    }
}
