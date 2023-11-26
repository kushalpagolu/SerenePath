//
//  SuccessView.swift
//  VoiceTherapy
//
//  Created by Kushal P on 3/26/23.
//
import SwiftUI
import CoreData
struct SuccessView: View {
    let changeView: (ViewType) -> Void
    @State private var checkmarkScale: CGFloat = 0.5
    @State private var checkmarkOpacity: Double = 0.0
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: ViewModel
    @State private var showAppointmentView = false

    var body: some View {
        if showAppointmentView {
            AddAppointmentView(changeView: changeView)
                .environmentObject(viewModel)
        } else {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                        .scaleEffect(checkmarkScale)
                        .opacity(checkmarkOpacity)
                        .onAppear {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
                                self.checkmarkScale = 1.0
                                self.checkmarkOpacity = 1.0
                            }
                        }
                    
                    Text("Success!")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("Welcome")
                        .foregroundColor(.white)
                        .padding()
                        .cornerRadius(15.0)
                        .frame(width: 220, height: 60)

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

struct SuccessView_Previews: PreviewProvider {
    static let viewModel = ViewModel()
    static var previews: some View {
        SuccessView(changeView: { _ in })
            .environmentObject(viewModel)
    }
}
