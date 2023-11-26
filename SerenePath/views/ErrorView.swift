//
//  ErrorView.swift
//  VoiceTherapy
//
//  Created by Kushal P on 3/27/23.
//
import SwiftUI

struct ErrorView: View {
    let changeView: (ViewType) -> Void
    var errorMessage: String
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: ViewModel
    @State private var animateErrorIcon = false

    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.white)
                .scaleEffect(animateErrorIcon ? 1.2 : 1)

            Text(errorMessage)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()

            Button(action: {
                changeView(.profile)
            }) {
                Text("Back to Main")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top)
            }
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(15)
        .shadow(radius: 10)
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                animateErrorIcon = true
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static let viewModel = ViewModel()
    static var previews: some View {
        ErrorView(changeView: { _ in }, errorMessage: "Prints error here")
            .environmentObject(viewModel)
    }
}
