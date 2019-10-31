//
//  ParseUtility.swift
//  OCD Therapy
//
//  Created by Adrian Avram on 10/5/19.
//  Copyright © 2019 KarsickKeep. All rights reserved.
//

import Foundation

class ParseUtility {
    static func verifyPassword(password: String) -> Bool {
        var document = DBUtility.documents()
        
        // 6 characters minimum, one capital, one lowercase, one digit required
        return password.range(of: "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)\\S{6,}$", options: .regularExpression) != nil
    }
    
    static func verifyEmail(email: String) -> Bool {
        // Verify email passes regex
        return email.range(of: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .regularExpression) != nil
    }
}
