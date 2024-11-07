//
//  NotaryDetailView.swift
//  NotaryAssistant
//
//  Created by STRRL on 2024-11-05.
//

import SwiftUI

struct NotaryDetailView: View {
    init(_ jobID: String) {
        notaryID = jobID
    }

    @State private var messages: [String] = []

    private var notaryID: String
    var body: some View {
        if notaryID.isEmpty {
        } else {
            VStack {
                Text(notaryID)
                List(messages, id: \.self) { message in
                    Text(message)
                }
            }.onChange(of: notaryID) { _, _ in
                do {
                    let logResult = try NotaryToolService.shared.fetchLog(notaryID)

                    var newMessages: [String] = []
                    logResult.issues?.forEach { issue in
                        newMessages
                            .append(
                                "\(issue.path):\(issue.architecture):\(issue.severity): \(issue.message)\n\(issue.docUrl)"
                            )
                    }
                    logResult.ticketContents?.forEach { ticketContent in
                        newMessages.append(
                            "\(ticketContent.path): \(ticketContent.arch) \(ticketContent.digestAlgorithm) \(ticketContent.cdhash)"
                        )
                    }



                    withAnimation {
                        messages = newMessages
                    }

                } catch {
                    print("Error, \(error)")
                }
            }
        }
    }
}

#Preview {
    NotaryDetailView("")
}
