//
//  Endpoints.swift
//  zMessagesFrontEnd
//
//  Created by Zak Lalani on 7/3/25.
//

import Foundation

struct Endpoints {
    static let base = "http://your_computer_IP:8080" //change to local IP
    static var createAccount: String { "\(base)/add-user" }
    static var getMessages: String { "\(base)/messages" }
    static var getUsers: String { "\(base)/users"}
}
