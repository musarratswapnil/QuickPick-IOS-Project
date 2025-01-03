import FirebaseFirestore
import Foundation
import SwiftUI
import Observation

@Observable
class HomeViewModel {
    let db = Firestore.firestore()
    var polls: [Poll] = [] // Published property for reactive updates
    var error: String? = nil
    var newPollName: String = ""
    var newOptionName: String = ""
    var newPollOptions: [String] = []

        
    var isLoading: Bool = false // Tracks loading state
    var isCreateNewPollButtonDisabled: Bool {
            isLoading ||
            newPollName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            newPollOptions.count < 2
        }
        
        var isAddOptionsButtonDisabled: Bool {
            isLoading ||
            newOptionName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            newPollOptions.count == 4
        }
        
    var errorMessage: String? // Stores error messages

    @MainActor
    func listenToLivePolls() {
        isLoading = true
        errorMessage = nil

        db.collection("polls")
            .order(by: "updatedAt", descending: true)
            .limit(toLast: 10)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }

                DispatchQueue.main.async {
                    self.isLoading = false

                    if let error = error {
                        print("Error fetching documents: \(error.localizedDescription)")
                        self.errorMessage = "Error fetching polls: \(error.localizedDescription)"
                        return
                    }

                    guard let snapshot = snapshot else {
                        print("Snapshot is nil")
                        self.errorMessage = "No data available"
                        return
                    }

                    // Decode Firestore documents into Poll objects
                    self.polls = snapshot.documents.compactMap { document in
                        do {
                            return try document.data(as: Poll.self)
                        } catch {
                            print("Error decoding document \(document.documentID): \(error)")
                            return nil
                        }
                    }

                    print("Fetched \(self.polls.count) polls")
                }
            }
    }
    
    @MainActor
    func createNewPoll() async {
        isLoading = true
        defer { isLoading = false }
        
        guard !newPollName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            error = "Poll name cannot be empty"
            return
        }
        
        guard newPollOptions.count >= 2 else {
            error = "You must have at least 2 options"
            return
        }

        let poll = Poll(
            name: newPollName.trimmingCharacters(in: .whitespacesAndNewlines),
            totalCount: 0,
            options: newPollOptions.map { Option(count: 0, name: $0) }
        )
        
        do {
            try await db.document("polls/\(poll.id)").setData(from: poll)
            newPollName = ""
            newPollOptions = []
            error = nil
        } catch {
            self.error = "Failed to create poll: \(error.localizedDescription)"
            print("Firestore error: \(error)")
        }
    }

    func addOption() {
        let trimmedName = newOptionName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            error = "Option name cannot be empty"
            return
        }
        guard newPollOptions.count < 4 else {
            error = "You can only add up to 4 options"
            return
        }
        self.newPollOptions.append(trimmedName)
        self.newOptionName = ""
    }

    
}

