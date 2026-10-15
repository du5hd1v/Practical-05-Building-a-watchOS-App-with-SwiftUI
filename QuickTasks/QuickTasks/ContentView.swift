import SwiftUI

struct ContentView: View {
    // Part B – Initial Tasks (At least 4 required)
    @State private var tasks: [TaskItem] = [
        TaskItem(title: "Morning Walk", completed: true, category: .health, priority: .high),
        TaskItem(title: "Drink Water", completed: false, category: .health, priority: .medium),
        TaskItem(title: "Read Notes", completed: false, category: .study, priority: .high),
        TaskItem(title: "Call Home", completed: true, category: .personal, priority: .low)
    ]

    @State private var showingAddSheet = false
    @State private var newTaskTitle = ""
    @State private var newTaskCategory: TaskCategory = .personal
    @State private var newTaskPriority: TaskPriority = .medium

    // Part E – Completion Count
    private var completedCount: Int {
        tasks.filter { $0.completed }.count
    }

    // Option B – Progress Percentage
    private var completionPercentage: Int {
        guard !tasks.isEmpty else { return 0 }
        return Int((Double(completedCount) / Double(tasks.count)) * 100)
    }

    var body: some View {
        NavigationStack {
            List {
                // Header Analytics Card
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("\(completedCount) / \(tasks.count) Completed")
                                .font(.headline)
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(completionPercentage)%")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.green)
                        }

                        // Compact Progress Bar
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.white.opacity(0.15))
                                    .frame(height: 6)

                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [.green, .cyan],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: max(6, geo.size.width * CGFloat(completedCount) / CGFloat(max(1, tasks.count))), height: 6)
                            }
                        }
                        .frame(height: 6)
                    }
                    .padding(.vertical, 4)
                    .listRowBackground(Color.white.opacity(0.08))
                }

                // Tasks List (Part C, D, F)
                Section(header: Text("Tasks")) {
                    ForEach($tasks) { $task in
                        HStack(spacing: 8) {
                            // Part D – Complete a Task Button (Toggles state)
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    task.completed.toggle()
                                }
                            }) {
                                Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                                    .font(.title3)
                                    .foregroundStyle(task.completed ? .green : .secondary)
                            }
                            .buttonStyle(.plain)

                            // NavigationLink to TaskDetailView
                            NavigationLink(destination: TaskDetailView(task: $task)) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(task.title)
                                        .font(.body)
                                        .fontWeight(task.completed ? .regular : .semibold)
                                        .strikethrough(task.completed, color: .secondary)
                                        .foregroundStyle(task.completed ? .secondary : .primary)

                                    HStack(spacing: 6) {
                                        Label(task.category.rawValue, systemImage: task.category.icon)
                                            .font(.system(size: 9))
                                            .foregroundStyle(task.category.color)

                                        Circle()
                                            .fill(task.priority.color)
                                            .frame(width: 4, height: 4)
                                    }
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteTask)
                }

                // Action Controls Section
                Section {
                    // Quick Add Task Button
                    Button(action: {
                        showingAddSheet = true
                    }) {
                        Label("Add Task", systemImage: "plus.circle.fill")
                            .foregroundStyle(.cyan)
                    }

                    // Option A – Reset Tasks Feature
                    Button(action: resetAllTasks) {
                        Label("Reset All", systemImage: "arrow.counterclockwise")
                            .foregroundStyle(.orange)
                    }
                }
            }
            .navigationTitle("Quick Tasks")
            .sheet(isPresented: $showingAddSheet) {
                addNewTaskSheet
            }
        }
    }

    // MARK: - Subviews & Actions

    private var addNewTaskSheet: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("New Task")
                    .font(.headline)
                    .padding(.top, 4)

                TextField("Task title", text: $newTaskTitle)

                Picker("Category", selection: $newTaskCategory) {
                    ForEach(TaskCategory.allCases) { category in
                        Text(category.rawValue).tag(category)
                    }
                }

                Picker("Priority", selection: $newTaskPriority) {
                    ForEach(TaskPriority.allCases) { priority in
                        Text(priority.rawValue).tag(priority)
                    }
                }

                Button("Save") {
                    let trimmed = newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    tasks.append(
                        TaskItem(
                            title: trimmed,
                            completed: false,
                            category: newTaskCategory,
                            priority: newTaskPriority
                        )
                    )
                    newTaskTitle = ""
                    showingAddSheet = false
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .disabled(newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
        }
    }

    private func resetAllTasks() {
        withAnimation {
            for index in tasks.indices {
                tasks[index].completed = false
            }
        }
    }

    private func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
