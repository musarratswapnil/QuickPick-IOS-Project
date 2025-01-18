import SwiftUI

struct AllPollsView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var vm = HomeViewModel()
    
    var sortedPolls: [Poll] {
        // Sort by creation date (newest first)
        vm.polls.sorted { ($0.createdAt ?? Date()) > ($1.createdAt ?? Date()) }
    }
    
    var body: some View {
        NavigationView {
            List(sortedPolls) { poll in
                VStack(alignment: .leading, spacing: 10) {
                    Text(poll.name)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 5)
                    
                    HStack {
                        Image(systemName: "chart.bar.xaxis")
                            .foregroundColor(.white)
                        Text("Total Votes: \(poll.totalCount)")
                            .foregroundColor(.white.opacity(0.8))
                        
                        Spacer()
                        
                        Text(poll.createdAt?.formatted(date: .numeric, time: .shortened) ?? "")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.caption)
                    }
                    
                    PollChartView(options: poll.options)
                        .frame(height: 160)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .listRowBackground(Color.black)
                .onTapGesture {
                    vm.modalPollId = poll.id
                    dismiss()
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.black)
            .navigationTitle("All Polls")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .onAppear {
                Task {
                    await vm.listenToLivePolls()
                }
            }
        }
    }
}

#Preview {
    AllPollsView()
} 