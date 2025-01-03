
import Foundation
import SwiftUI

struct HomeView: View {
    var vm = HomeViewModel()
    
    var body: some View {
        List {
            livePollsSection
        }
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
                    }
                }
            }
        }
    }
}
