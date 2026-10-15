import SwiftUI

enum TaskCategory: String, CaseIterable, Identifiable, Codable {
    case health = "Health"
    case study = "Study"
    case personal = "Personal"
    case work = "Work"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .health: return "heart.fill"
        case .study: return "book.fill"
        case .personal: return "person.fill"
        case .work: return "briefcase.fill"
        }
    }

    var color: Color {
        switch self {
        case .health: return .green
        case .study: return .blue
        case .personal: return .purple
        case .work: return .orange
        }
    }
}

enum TaskPriority: String, CaseIterable, Identifiable, Codable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .high: return .red
        case .medium: return .orange
        case .low: return .gray
        }
    }
}

struct TaskItem: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var completed: Bool
    var category: TaskCategory
    var priority: TaskPriority

    init(
        id: UUID = UUID(),
        title: String,
        completed: Bool = false,
        category: TaskCategory = .personal,
        priority: TaskPriority = .medium
    ) {
        self.id = id
        self.title = title
        self.completed = completed
        self.category = category
        self.priority = priority
    }
}
