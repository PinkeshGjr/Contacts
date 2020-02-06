//
//  ContactDetailsViewModel.swift
//  contact
//
//  Created by Pinkesh Gjr on 05/02/20.
//  Copyright © 2020 Pinkesh Gjr. All rights reserved.
//

import Foundation

class contactDetailsViewModel {
    
    enum fields: Int,CaseIterable {
        case mobileNumber = 0
        case email
        case delete
    }
    
    struct detailsModel: Codable {
        var id: Int?
        var firstName: String?
        var lastName: String?
        var profilePic: String?
        var favourite: Bool = false
        var createdDate: String?
        var updatedDate: String?
        var phoneNumber: String?
        var email: String?
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case firstName = "first_name"
            case lastName = "last_name"
            case profilePic = "profile_pic"
            case favourite = "favorite"
            case createdDate = "created_date"
            case updatedDate = "updated_date"
            case phoneNumber = "phone_number"
            case email = "email"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decodeIfPresent(Int.self, forKey: .id)
            firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
            lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
            profilePic = try values.decodeIfPresent(String.self, forKey: .profilePic)
            favourite = try (values.decodeIfPresent(Bool.self, forKey: .favourite) ?? false)
            createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
            updatedDate = try values.decodeIfPresent(String.self, forKey: .updatedDate)
            phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber)
            email = try values.decodeIfPresent(String.self, forKey: .email)
        }
    }
}
