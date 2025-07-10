//
//  WhichUser.swift
//  zMessagesFrontEnd
//

import SwiftUI

struct WhichUser: View {
    @State private var totalUsers: [User] = []
    
    var body: some View {
        ScrollView {
            ForEach(totalUsers) { userProfile in
                Text(userProfile.username) //make this a button that links to users and u can select each contact and get convos
            }
        }
        .onAppear{
            fetchAllUsers { result in
                    switch result { //the function returns nothing
                    case .success(let userProfiles):
                        totalUsers = userProfiles
                        for userProfile in userProfiles {
                            print(userProfile.id) //zz we can just use the ID's
                        }
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
            }
        }
    }
}

#Preview {
    WhichUser()
}
