import SwiftUI

struct TaskDetailView: View {
    @Binding var task: TaskItem

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Large Status Toggle Button
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        task.completed.toggle()
                    }
                }) {
                    VStack(spacing: 6) {
                        Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 40))
                            .foregroundStyle(task.completed ? .green : .gray)

                        Text(task.completed ? "Completed" : "Pending")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(task.completed ? .green : .secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
                .buttonStyle(.bordered)
                .tint(task.completed ? .green : .secondary)

                // Task Title
                Text(task.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Divider()

                // Category & Priority Metadata Cards
                VStack(spacing: 8) {
                    HStack {
                        Label(task.category.rawValue, systemImage: task.category.icon)
                            .font(.caption)
                            .foregroundStyle(task.category.color)
                        Spacer()
                        Text("Category")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    HStack {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(task.priority.color)
                                .frame(width: 8, height: 8)
                            Text(task.priority.rawValue + " Priority")
                                .font(.caption)
                                .foregroundStyle(.primary)
                        }
                        Spacer()
                        Text("Priority")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding(.horizontal, 4)
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        TaskDetailView(
            task: .constant(
                TaskItem(title: "Morning Walk", completed: true, category: .health, priority: .high)
            )
        )
    }
}
