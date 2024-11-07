//
//  LoggingService.swift
//  NotaryAssistant
//
//  Created by STRRL on 2024-11-05.
//

import Foundation

struct LoggingEntry: Identifiable {
    let id = UUID()
    let datetime: Date
    let cmd: String
    var stdout: String
    var stderr: String
}

final class LoggingService: ObservableObject {
    public static var shared: LoggingService = .init()

    @Published
    public var entries: [LoggingEntry] = []

    private var store: [UUID: LoggingEntry] = [:]

    public func log(cmd: String, stdout: String, stderr: String) {
        let entry = LoggingEntry(datetime: Date(), cmd: cmd, stdout: stdout, stderr: stderr)
        store[entry.id] = entry
        updateComputedEntries()
    }

    public func appendStdout(id: UUID, stdout: String) {
        store[id]?.stdout.append(stdout)
        updateComputedEntries()
    }

    public func appendStderr(id: UUID, stderr: String) {
        store[id]?.stderr.append(stderr)
        updateComputedEntries()
    }

    private func updateComputedEntries() {
        entries = store.map(\.value)
    }
}
