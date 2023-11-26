//
//  RegistrationView.swift
//  VoiceTherapy
//
//  Created by Kushal P on 3/26/23.
//
import Foundation
import SwiftUI

struct RegistrationView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: ViewModel // Updated to @EnvironmentObject
    let changeView: (ViewType) -> Void
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var selectedRole: String = "Patient" 
    @State private var navigateToAddProfileDetails = false
    @State private var registeredUser: User?
    @State private var isTherapist = false
    // Add this state variable to control navigation
    @State private var errorMessage = ""
    @State private var showRegistrationSuccessful = false
    @State private var showErrorAlert = false
    @State private var showErrorView = false

    let roles = ["Patient", "Therapist"] // Add this array to store the roles

    var body: some View {
        if navigateToAddProfileDetails {
            AddProfileDetailsView(changeView: changeView, isTherapist: isTherapist, username: (registeredUser?.username)!)
                .environmentObject(viewModel)
        }
        
        else if showRegistrationSuccessful {
            RegistrationSuccessfulView(registeredUser: registeredUser!, changeView: changeView)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        navigateToAddProfileDetails = true
                    }
                }
        }
        else {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(hex: "#F1C9EC"), Color(hex: "#AB84CB")]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Text("Registration")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)

                    TextField("Username", text: $username)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)

                    TextField("Email", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.top)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.top)

                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.top)

                    // Add this Picker to choose the role
                    Picker("Role", selection: $selectedRole) {
                        ForEach(roles, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .padding(.top)

                    Button(action: {
                        isTherapist = selectedRole == "Therapist"
                        (showRegistrationSuccessful, registeredUser) = viewModel.registerUser(viewContext: viewContext, username: username, email: email, password: password, isTherapist: isTherapist)

                        if registeredUser != nil {
                            print("Registered User")
                        } else {
                            showErrorAlert = true
                            print("Registration failed.")
                        }
                    }) {
                        Text("Register")
                            .foregroundColor(.white)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(15.0)
                            .frame(width: 220, height: 60)
                            .padding()
                    }.alert(isPresented: $showErrorAlert) {
                        Alert(title: Text("Please verify the details entered and try again"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                    }
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
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(changeView: { _ in })
            .environmentObject(ViewModel())

    }
}
