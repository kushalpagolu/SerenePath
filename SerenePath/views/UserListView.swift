//
//  UserListView.swift
//  VoiceTherapy
//
//  Created by Kushal P on 3/26/23.
//

import SwiftUI
import CoreData

struct UserListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: User.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \User.username, ascending: true)], animation: .default) var users: FetchedResults<User>
    let changeView: (ViewType) -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(hex: "#FED9B7"), Color(hex: "#F07167")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Registered Users")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                Text("Total Registered Users \(users.count)")

                
                List(users) { user in
                    VStack(alignment: .leading) {
                        Text(user.username ?? "")
                            .foregroundColor(.white)
                        Text(user.email ?? "")
                            .foregroundColor(.white)
                    }
                }
                .background(Color.clear)
                .listStyle(PlainListStyle())
                Button("Back to main") {
                    changeView(.main)
                }
                .foregroundColor(.white)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(15.0)
                .frame(width: 220, height: 60)
                .padding()
            }
        }
    }
}


struct UserListView_Previews: PreviewProvider {
    static let viewContext = PersistenceController.preview.container.viewContext
    
    static func addDummyUser() {
        let user1 = User(context: viewContext)
        user1.username = "john_doe"
        user1.email = "hjdkshdjka@gmail.com"
        
        let user2 = User(context: viewContext)
        user2.username = "jane_doe"
        user2.email = "dhasjadk@hotmail.com"
        
        do {
            try viewContext.save()
        } catch {
            print("Error saving dummy patients: \(error.localizedDescription)")
        }
    }
    
    static var previews: some View {
        addDummyUser()
        return UserListView(changeView: { _ in }) 
            .environment(\.managedObjectContext, viewContext)
    }
}

