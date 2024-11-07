//
//  PageHistoryView.swift
//  NotaryAssistant
//
//  Created by STRRL on 2024-11-05.
//

import SwiftUI

extension Date {
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: self, to: now)

        if let days = components.day, days > 7 {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, yyyy HH:mm"
            return formatter.string(from: self)
        } else {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            return formatter.localizedString(for: self, relativeTo: now)
        }
    }
}

struct PageHistoryView: View {
    @State var history: [NotaryHistoryEntry] = []
    @State var selection: String? = nil

    var body: some View {
        HStack {
            List($history, id: \.id,
                 selection: $selection)
            { $entry in
                Group {
                    Text(
                        "\(entry.name) \n\(notaryStatusEmoji(entry.status)) \(entry.status.rawValue) \n\(entry.createdDate.timeAgoDisplay())"
                    )
                }
            }
            .frame(width: 240)
            .onAppear {
                do {
                    let output = try NotaryToolService.shared.fetchHistory()
                    history = output.history
                } catch {
                    print("Error, \(error)")
                }
            }
            .refreshable {
                do {
                    let output = try NotaryToolService.shared.fetchHistory()
                    history = output.history
                } catch {
                    print("Error, \(error)")
                }
            }

            Group {
                if selection != nil {
                    NotaryDetailView(selection ?? "")
                } else {
                    Text("Please select an entry")
                }
            }.frame(
                minWidth: 320, maxWidth: .infinity,
                minHeight: 240, maxHeight: .infinity
            )
        }
    }

    func notaryStatusEmoji(_ status: NotaryStatus) -> String {
        switch status {
        case .inProgress:
            "⏳"
        case .accepted:
            "✅"
        case .invalid:
            "⚠️"
        case .rejected:
            "❌"
        }
    }
}

#Preview {
    PageHistoryView()
}
