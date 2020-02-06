//
//  HomeViewModel.swift
//  contact
//
//  Created by Pinkesh Gjr on 04/02/20.
//  Copyright © 2020 Pinkesh Gjr. All rights reserved.
//

import Foundation

class HomeViewModel {
    
    struct homeModelClass: Codable {
        var id: Int?
        var firstName: String?
        var lastName: String?
        var profilePic: String?
        var favourite: Bool = false
        var url: String?
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case firstName = "first_name"
            case lastName = "last_name"
            case profilePic = "profile_pic"
            case favourite = "favorite"
            case url = "url"
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decodeIfPresent(Int.self, forKey: .id)
            firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
            lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
            profilePic = try values.decodeIfPresent(String.self, forKey: .profilePic)
            favourite = try (values.decodeIfPresent(Bool.self, forKey: .favourite) ?? false)
            url = try values.decodeIfPresent(String.self, forKey: .url)
        }
        
        var firstCharacter: String {
            return getFirstCharacter(string: String(firstName?.prefix(1) ?? "#"))
        }
        
        func getFirstCharacter(string: String) -> String {
            if containsOnlyLetters(input: string){
                let str = String(string.prefix(1)).uppercased()
                return str
            }else{
                return "#"
            }
        }
        
        func containsOnlyLetters(input: String) -> Bool {
           for chr in input {
              if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                 return false
              }
           }
           return true
        }
    }
}
