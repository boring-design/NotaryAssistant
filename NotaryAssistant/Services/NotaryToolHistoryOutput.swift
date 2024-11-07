//
//  NotaryToolHistoryOutput.swift
//  NotaryAssistant
//
//  Created by STRRL on 2024-11-06.
//
import Foundation

struct NotaryToolHistoryOutput: Codable {
    let message: String
    let history: [NotaryHistoryEntry]
}

struct NotaryHistoryEntry: Codable {
    let id: String
    let createdDate: Date
    let name: String
    let status: NotaryStatus

    enum CodingKeys: String, CodingKey {
        case status, id, createdDate, name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(NotaryStatus.self, forKey: .status)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)

        let dateString = try container.decode(String.self, forKey: .createdDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        if let date = dateFormatter.date(from: dateString) {
            createdDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .createdDate, in: container, debugDescription: "Date string does not match format")
        }
    }
}

enum NotaryStatus: String, Codable {
    case accepted = "Accepted"
    case inProgress = "In Progress"
    case invalid = "Invalid"
    case rejected = "Rejected"
}
