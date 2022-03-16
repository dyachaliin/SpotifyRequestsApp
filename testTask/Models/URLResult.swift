//
//  URLResult.swift
//  testTask
//
//  Created by Алина Дьяченко on 09.03.2022.
//

import Foundation

struct URLResult: Decodable {
    let accessToken, tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}
