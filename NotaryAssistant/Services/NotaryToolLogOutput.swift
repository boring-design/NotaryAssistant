//
//  NotaryToolLogOutput.swift
//  NotaryAssistant
//
//  Created by STRRL on 2024-11-06.

import Foundation

struct NotaryToolLogOutput: Codable {
    let logFormatVersion: Int
    let jobId: String
    let status: String
    let statusSummary: String
    let statusCode: Int
    let archiveFilename: String
    let uploadDate: String
    let sha256: String
    let ticketContents: [TicketContent]?
    let issues: [Issue]?
}

struct TicketContent: Codable {
    let path: String
    let digestAlgorithm: String
    let cdhash: String
    let arch: String
}

struct Issue: Codable {
    let severity: String
    let code: String?
    let path: String
    let message: String
    let docUrl: String
    let architecture: String
}
