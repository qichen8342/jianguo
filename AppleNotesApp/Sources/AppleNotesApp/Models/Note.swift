import Foundation

struct Note: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var content: String
    var createdAt: Date
    var updatedAt: Date
    var isPinned: Bool = false
    var tags: [String] = []

    init(title: String = "无标题", content: String = "") {
        self.title = title
        self.content = content
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    var preview: String {
        let lines = content.components(separatedBy: "\n").filter { !$0.isEmpty }
        return lines.first ?? "暂无内容"
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        if calendar.isDateInToday(updatedAt) {
            formatter.dateFormat = "HH:mm"
        } else if calendar.isDateInYesterday(updatedAt) {
            return "昨天"
        } else {
            formatter.dateFormat = "yyyy/MM/dd"
        }
        return formatter.string(from: updatedAt)
    }
}
