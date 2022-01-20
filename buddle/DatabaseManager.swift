//
//  DatabaseManager.swift
//  buddle
//
//  Created by Vu Quang Huy on 21/11/2021.
//

import Foundation

final class DatabaseManager {
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    static func generateImageName() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmSS"
        let result = formatter.string(from: date)
        return result
     }
}
