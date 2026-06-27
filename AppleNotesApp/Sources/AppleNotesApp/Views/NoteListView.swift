import SwiftUI

struct NoteListView: View {
    @EnvironmentObject var store: NoteStore

    var body: some View {
        VStack(spacing: 0) {
            SearchBar(text: $store.searchText)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)

            Divider()

            if store.filteredNotes.isEmpty {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "note.text")
                        .font(.system(size: 40))
                        .foregroundStyle(.tertiary)
                    Text(store.searchText.isEmpty ? "暂无笔记" : "无搜索结果")
                        .foregroundStyle(.secondary)
                }
                Spacer()
            } else {
                List(store.filteredNotes, selection: $store.selectedNoteID) { note in
                    NoteRowView(note: note)
                        .tag(note.id)
                        .contextMenu {
                            Button(note.isPinned ? "取消置顶" : "置顶笔记") {
                                store.togglePin(id: note.id)
                            }
                            Divider()
                            Button("删除笔记", role: .destructive) {
                                store.deleteNote(id: note.id)
                            }
                        }
                }
                .listStyle(.sidebar)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: store.createNote) {
                    Image(systemName: "square.and.pencil")
                }
                .help("新建笔记 (⌘N)")
            }
        }
    }
}

struct NoteRowView: View {
    let note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack {
                if note.isPinned {
                    Image(systemName: "pin.fill")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                }
                Text(note.title.isEmpty ? "无标题" : note.title)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
                Text(note.formattedDate)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(note.preview)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(.vertical, 2)
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("搜索笔记", text: $text)
                .textFieldStyle(.plain)
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
    }
}
