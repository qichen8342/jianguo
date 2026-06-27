import SwiftUI
import Combine

@MainActor
class NoteStore: ObservableObject {
    @Published var notes: [Note] = []
    @Published var selectedNoteID: UUID?
    @Published var searchText: String = ""

    private let saveKey = "saved_notes"

    var selectedNote: Binding<Note>? {
        guard let id = selectedNoteID,
              let index = notes.firstIndex(where: { $0.id == id }) else { return nil }
        return Binding(
            get: { self.notes[index] },
            set: { self.notes[index] = $0; self.save() }
        )
    }

    var filteredNotes: [Note] {
        let sorted = notes.sorted {
            if $0.isPinned != $1.isPinned { return $0.isPinned }
            return $0.updatedAt > $1.updatedAt
        }
        guard !searchText.isEmpty else { return sorted }
        return sorted.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.content.localizedCaseInsensitiveContains(searchText)
        }
    }

    init() {
        load()
        if notes.isEmpty {
            let welcome = Note(title: "欢迎使用苹果笔记", content: "这是您的第一条笔记。\n\n您可以：\n• 按 ⌘N 新建笔记\n• 点击左侧列表切换笔记\n• 使用搜索栏快速查找")
            notes.append(welcome)
            selectedNoteID = welcome.id
            save()
        }
    }

    func createNote() {
        let note = Note()
        notes.insert(note, at: 0)
        selectedNoteID = note.id
        save()
    }

    func deleteNote(id: UUID) {
        notes.removeAll { $0.id == id }
        if selectedNoteID == id {
            selectedNoteID = filteredNotes.first?.id
        }
        save()
    }

    func togglePin(id: UUID) {
        guard let index = notes.firstIndex(where: { $0.id == id }) else { return }
        notes[index].isPinned.toggle()
        save()
    }

    func updateNote(_ note: Note) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else { return }
        var updated = note
        updated.updatedAt = Date()
        notes[index] = updated
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let decoded = try? JSONDecoder().decode([Note].self, from: data) else { return }
        notes = decoded
        selectedNoteID = notes.first?.id
    }
}
