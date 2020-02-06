//
//  EditViewModel.swift
//  contact
//
//  Created by Pinkesh Gjr on 05/02/20.
//  Copyright © 2020 Pinkesh Gjr. All rights reserved.
//

import Foundation

class EditViewModel {
    
    enum fields: Int,CaseIterable {
        case firstName = 0
        case lastName
        case mobile
        case email
    }
    
    struct fieldValues {
        var firstName: String = ""
        var lastName: String = ""
        var mobile: String = ""
        var email: String = ""
        var favourite: Bool = false
    }
    
    enum validationMessage: String {
        case emptyFirstName = "Please enter the first name"
        case emptyLastName = "Please enter the last name"
        case emptyMobile = "Please enter phone number"
        case emptyEmail = "Please enter email address"
    }
}
