//
//  ContentView.swift
//  NotaryAssistant
//
//  Created by STRRL on 2024-11-04.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: String? = nil
    var body: some View {
        HStack {
            NavigationSplitView {
                List(selection: $selection) {
                    Section(header: Text("Main")) {
                        NavigationLink(value: "history") {
                            Label("Notary History", systemImage: "clock")
                        }
                        NavigationLink(value: "logs") {
                            Label("Logs", systemImage: "list.bullet")
                        }
                    }

                    Section(header: Text("Settings")) {
                        NavigationLink(value: "credentials") {
                            Label("Credentials", systemImage: "key")
                        }
                    }
                }
                .navigationSplitViewColumnWidth(160)
            } detail: {
                Group {
                    if selection == "history" {
                        PageHistoryView()
                    } else if selection == "logs" {
                        Text("Page Logs")
                    } else if selection == "credentials" {
                        PageCredentialsView()
                    }
                }
            }
            .navigationTitle("Notary Assistant")
        }
    }
}

#Preview {
    ContentView()
}
