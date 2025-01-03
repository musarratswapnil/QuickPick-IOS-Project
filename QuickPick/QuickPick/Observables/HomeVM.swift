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
    var newPollOptions: String = ""
        
    var isLoading: Bool = false // Tracks loading state
    var isCreateNewPollButtonDisabled: Bool {
            isLoading ||
            newPollName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            newPollOptions.count < 2
        }
        
        var isAddOptionsButtonDisabled: Bool {
            isLoading ||
            newOptionName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            newPollOptions.count >= 4
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
}

