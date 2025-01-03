
import Foundation
import SwiftUI

struct HomeView: View {
    @Bindable var vm = HomeViewModel()
    
    var body: some View {
        List {
            livePollsSection
            createPollsSection
            addOptionsSection
        }
        .navigationTitle("LivePolls")
        .onAppear {
            vm.listenToLivePolls()
        }
    }
    
    var livePollsSection: some View {
        Section {
            DisclosureGroup("Latest Live Polls") {
                ForEach(vm.polls) { poll in
                    VStack {
                        HStack(alignment: .top) {
                            Text(poll.name)
                            Spacer()
                            Image(systemName: "chart.bar.xaxis")
                            Text(String(poll.totalCount))
                        }
                        if let updatedAt = poll.updatedAt {
                            HStack {
                                Image(systemName: "clock.fill")
                                Text(updatedAt, style: .time)
                            }
                        }
                        PollChartView(options: poll.options)
                            .frame(height: 160)
                    }
                }
            }
        }
    }
    
    var createPollsSection: some View {
            Section {
                TextField("Enter poll name", text: $vm.newPollName, axis: .vertical)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                Button("Submit") {
                    // Submit action
                }
                .disabled(vm.isCreateNewPollButtonDisabled)
                
                if vm.isLoading {
                    ProgressView()
                }
            } header: {
                Text("Create a Poll")
            } footer: {
                Text("Enter poll name & add 2-4 options to submit")
            }
        }
    
    var addOptionsSection: some View{
        Section{
            
        }
    }
    
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
