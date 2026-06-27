import SwiftUI

struct NoteEditorView: View {
    @Binding var note: Note
    @EnvironmentObject var store: NoteStore
    @FocusState private var contentFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField("标题", text: $note.title)
                .font(.title2.bold())
                .textFieldStyle(.plain)
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 8)
                .onChange(of: note.title) { store.updateNote(note) }

            Divider()
                .padding(.horizontal, 24)

            HStack {
                Text(note.updatedAt.formatted(.dateTime.year().month().day().hour().minute()))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                if !note.tags.isEmpty {
                    ForEach(note.tags, id: \.self) { tag in
                        TagView(tag: tag)
                    }
                }
                Spacer()
                Text("\(note.content.count) 字")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 8)

            TextEditor(text: $note.content)
                .font(.body)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .focused($contentFocused)
                .onChange(of: note.content) { store.updateNote(note) }
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: { store.togglePin(id: note.id) }) {
                    Image(systemName: note.isPinned ? "pin.slash" : "pin")
                }
                .help(note.isPinned ? "取消置顶" : "置顶笔记")

                Button(action: { store.deleteNote(id: note.id) }) {
                    Image(systemName: "trash")
                }
                .help("删除笔记 (⌘⌫)")
            }
        }
        .onAppear { contentFocused = note.content.isEmpty }
    }
}

struct TagView: View {
    let tag: String

    var body: some View {
        Text("#\(tag)")
            .font(.caption)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(.blue.opacity(0.1), in: Capsule())
            .foregroundStyle(.blue)
    }
}
