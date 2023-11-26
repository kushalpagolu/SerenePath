//
//  LoginView.swift
//  VoiceTherapy
//
//  Created by Kushal P on 3/26/23.
//

import SwiftUI
import CoreData

struct LoginView: View {
    let changeView: (ViewType) -> Void
    @State private var isLoggedIn = false
    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showErrorAlert = false
    @State private var showErrorView = false
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var loggedInUser: User?
    @Binding var currentView: ViewType

    var body: some View {
        if isLoggedIn {
                   LoginSuccessfulView(loggedInUser: $loggedInUser, changeView: changeView, currentView: $currentView)
                       .environmentObject(viewModel)
               }
        else if showErrorView {
            ErrorView(changeView: changeView, errorMessage: errorMessage)
                .transition(.move(edge: .bottom))
        }
        else {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(hex: "#F1C9EC"), Color(hex: "#AB84CB")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Text("Login View")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.top, 50)

                    TextField("Username", text: $username)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                    Button(action: {
                        let loginResult = viewModel.loginUser(viewContext: viewContext, username: username, password: password)
                        switch loginResult {
                        case .success(let loggedInUser):
                            self.loggedInUser = loggedInUser
                            isLoggedIn = true
                        case .failure(let error):
                            switch error {
                            case .invalidCredentials:
                                errorMessage = "Invalid username or password."
                            case .fetchError(let description):
                                errorMessage = "Error fetching users: \(description)"
                            }
                            showErrorAlert = true
                            showErrorView = true
                        }
                    }) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(15.0)
                    }
             /*       .alert(isPresented: $showErrorAlert) {
                        Alert(title: Text("Login Failed"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                    }
                    */
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
                .padding()
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(changeView: { _ in }, loggedInUser: .constant(nil), currentView: .constant(.main))
            .environmentObject(ViewModel())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
