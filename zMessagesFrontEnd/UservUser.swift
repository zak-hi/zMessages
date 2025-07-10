//
//  UservUser.swift
//  zMessagesFrontEnd
//

import SwiftUI

struct UservUser: View {
    let user: User //now this is linked to a specific user object
    @State private var totalUsers: [User] = []

    var body: some View {
        Text(user.username)
        ScrollView {
            ForEach(totalUsers) { userProfile in
                //zz do not want to show if self as a user
                NavigationLink(userProfile.username, destination: ConversationView(user1: user, user2: userProfile)) //this should now lead to get convos
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
//    UservUser(user: )
}
