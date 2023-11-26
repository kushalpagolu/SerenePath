//
//  extensions.swift
//  VoiceTherapy
//
//  Created by Kushal P on 3/26/23.
//

import Foundation
import SwiftUI
import CoreData

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 1)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}


extension Therapist {
    func update(from json: [String: Any]) throws {
        guard let id = json["id"] as? String,
              let firstName = json["firstName"] as? String,
              let lastName = json["lastName"] as? String,
              let username = json["username"] as? String,
              let email = json["email"] as? String,
              let contactNumber = json["contactNumber"] as? String,
              let dateOfBirthStr = json["dateOfBirth"] as? String,
              let gender = json["gender"] as? String,
              let availability = json["availability"] as? String,
              let bio = json["bio"] as? String,
              let specialization = json["specialization"] as? String
        else {
            throw NSError(domain: "JSONError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Missing required field(s) in JSON"])
        }

        self.id = UUID(uuidString: id)
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.email = email
        self.contactNumber = contactNumber

        // Convert dateOfBirth string to Date object
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let dateOfBirth = dateFormatter.date(from: dateOfBirthStr) {
            self.dateOfBirth = dateOfBirth
        } else {
            throw NSError(domain: "JSONError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid date format in JSON"])
        }

        self.gender = gender
        self.availability = availability
        self.bio = bio
        self.specialization = specialization
    }
}


extension Service {
    convenience init(from preview: ServicePreview, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = preview.id
        self.name = preview.name
        self.price = preview.price
        self.serviceDescription = preview.serviceDescription
        self.serviceDuration = preview.serviceDuration
        self.serviceImage = preview.serviceImage
    }
}
