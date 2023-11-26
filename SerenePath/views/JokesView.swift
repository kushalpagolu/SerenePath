//
//  JokesView.swift
//  VoiceTherapy
//
//  Created by Kushal P on 3/27/23.
//
import SwiftUI

struct JokesView: View {
    @EnvironmentObject var viewModel: ViewModel
    @StateObject private var jokesModel = JokesViewModel()
    @State private var textOpacity: Double = 0
    let closeAction: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Spacer()

                    Button("Close") {
                        closeAction()
                    }
                    .foregroundColor(.white)
                    .padding()
                }

                Spacer()

                Text(jokesModel.joke)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .opacity(textOpacity)
                    .animation(.easeInOut(duration: 0.5), value: textOpacity)
                
                Spacer()
                
                Button("More") {
                    textOpacity = 0
                    jokesModel.fetchJoke()
                    withAnimation {
                        textOpacity = 1
                    }
                }
                .foregroundColor(.white)
                .padding()
                /*
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)) */
                .cornerRadius(15.0)
                .frame(width: 220, height: 60)
                .padding(.bottom)
            }
        }
        
        .onAppear {
            jokesModel.fetchJoke()
            withAnimation {
                textOpacity = 1
            }
        }
    }
}

/*
struct JokesView_Previews: PreviewProvider {
    static var previews: some View {
        JokesView(viewModel: ViewModel(), closeAction: {})
    }
}

*/
