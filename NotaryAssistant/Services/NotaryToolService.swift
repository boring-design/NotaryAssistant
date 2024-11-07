//
//  NotaryToolService.swift
//  NotaryAssistant
//
//  Created by STRRL on 2024-11-05.
//

import Foundation

final class NotaryToolService {
    public static var shared: NotaryToolService = .init(
        loggingService: LoggingService.shared,
        credentialService: CredentialService.shared
    )

    private var loggingService: LoggingService
    private var credentialService: CredentialService

    init(loggingService: LoggingService, credentialService: CredentialService) {
        self.loggingService = loggingService
        self.credentialService = credentialService
    }

    public func fetchHistory() throws -> NotaryToolHistoryOutput {
        let credentials = credentialService.loadCredentials()
        let cmd = "xcrun notarytool history --output-format json --apple-id \(credentials.appleID) --password \(credentials.password) --team-id \(credentials.teamID) -v"
        let auditCmd = "xcrun notarytool audit-log --output-format json --apple-id \(credentials.appleID) --password <password-truncated> --team-id \(credentials.teamID) -v"
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["bash", "-c", cmd]
        let stdoutPipe = Pipe()
        let stderrPipe = Pipe()
        task.standardOutput = stdoutPipe
        task.standardError = stderrPipe
        task.standardInput = nil
        task.launch()
        task.waitUntilExit()
        task.terminate()

        let stdoutData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
        let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()
        let stdout = String(data: stdoutData, encoding: .utf8) ?? ""
        let stderr = String(data: stderrData, encoding: .utf8) ?? ""

        loggingService.log(cmd: auditCmd, stdout: stdout, stderr: stderr)

        let notaryToolOutput = try JSONDecoder().decode(NotaryToolHistoryOutput.self, from: Data(stdout.utf8))
        return notaryToolOutput
    }

    public func fetchLog(_ jobID: String) throws -> NotaryToolLogOutput {
        let credentials = credentialService.loadCredentials()
        let cmd = "xcrun notarytool log \(jobID) --output-format json --apple-id \(credentials.appleID) --password \(credentials.password) --team-id \(credentials.teamID) -v"
        let auditCmd = "xcrun notarytool audit-log \(jobID) --output-format json --apple-id \(credentials.appleID) --password <password-truncated> --team-id \(credentials.teamID) -v"
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = ["bash", "-c", cmd]
        let stdoutPipe = Pipe()
        let stderrPipe = Pipe()
        task.standardOutput = stdoutPipe
        task.standardError = stderrPipe
        task.standardInput = nil
        task.launch()
        task.waitUntilExit()
        task.terminate()

        let stdoutData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
        let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()
        let stdout = String(data: stdoutData, encoding: .utf8) ?? ""
        let stderr = String(data: stderrData, encoding: .utf8) ?? ""

        loggingService.log(cmd: auditCmd, stdout: stdout, stderr: stderr)

        let notaryToolOutput = try JSONDecoder().decode(NotaryToolLogOutput.self, from: Data(stdout.utf8))
        return notaryToolOutput
    }
}
