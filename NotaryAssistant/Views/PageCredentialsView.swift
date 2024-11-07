//
//  PageCredentialsView.swift
//  NotaryAssistant
//
//  Created by STRRL on 2024-11-05.
//
//

import SwiftUI

struct PageCredentialsView: View {
    @State private var appleID = ""
    @State private var password = ""
    @State private var teamID = ""
    @State private var showCheckmark = false

    // Add CredentialService
    private let credentialService = CredentialService.shared

    var body: some View {
        Form {
            Section(
                header: Text("Apple Developer Credentials").padding(.bottom, 20)
            ) {
                TextField("Apple ID", text: $appleID)
                    .textContentType(.emailAddress)
                    .autocorrectionDisabled(true)

                Text("Email address of your Apple Developer account")
                    .font(.caption)
                    .foregroundColor(.secondary)

                SecureField("Password", text: $password)

                Link("Create app-specific passwords", destination: URL(string: "https://support.apple.com/en-ca/102654")!)
                    .font(.footnote)
                    .foregroundColor(.blue)
                    .underline()

                TextField("Team ID", text: $teamID)

                Link("Find my Team ID", destination: URL(string: "https://developer.apple.com/help/account/manage-your-team/locate-your-team-id")!)
                    .font(.footnote)
                    .foregroundColor(.blue)
                    .underline()
            }

            Section {
                HStack {
                    Button(action: submitCredentials) {
                        Text("Save Credentials")
                    }
                    .disabled(appleID.isEmpty || password.isEmpty || teamID.isEmpty)

                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .opacity(showCheckmark ? 1 : 0)
                        .scaleEffect(showCheckmark ? 1 : 0.5)
                }
            }.padding(.top, 10)
        }
        .padding()
        .navigationTitle("Developer Credentials")
        .onAppear(perform: loadCredentials)
        .animation(.easeInOut, value: showCheckmark)
    }

    private func submitCredentials() {
        credentialService.saveCredentials(appleID: appleID, password: password, teamID: teamID)
        // Replace print statement with this
        showCheckmark = true
        // Hide checkmark after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            showCheckmark = false
        }
    }

    private func loadCredentials() {
        let credentials = credentialService.loadCredentials()
        appleID = credentials.appleID
        password = credentials.password
        teamID = credentials.teamID
    }
}

struct PageCredentialsView_Previews: PreviewProvider {
    static var previews: some View {
        PageCredentialsView()
    }
}
