//
//  ServiceDetailView.swift
//  VoiceTherapy
//
//  Created by Kushal P on 4/2/23.
//

import SwiftUI
struct ServiceDetailView: View {
    var service: Service
    @Binding var showDetail: Bool
    @State private var isLoaded = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(hex: "#DDEDB6"), Color(hex: "#969DD3")]), startPoint: .top, endPoint: .bottom)
                            .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Text(service.name ?? "")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.top)

                if isLoaded {
                    Text(service.serviceDescription ?? "")
                        .foregroundColor(.black)
                        .padding(.top)

                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.black)
                        Text("Duration: \(service.serviceDuration) minutes")
                            .foregroundColor(.black)
                    }
                    .padding(.top)

                    HStack {
                        Image(systemName: "dollarsign.circle")
                            .foregroundColor(.black)
                        Text("Price: $\(service.price)")
                            .foregroundColor(.black)
                    }
                    .padding(.top)
                    
                    Image(service.serviceImage ?? "placeholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 280)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .padding(.top, 30)
                }

                Spacer()

                Button(action: {
                    withAnimation {
                        showDetail.toggle()
                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                    }
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(15)
                    .padding(.bottom, 30)
                    .padding(.horizontal, 20)
                }
            }
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color("GradientStart"), Color("GradientEnd")]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea())
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        isLoaded = true
                    }
                }
        }
        }
    }
}

struct ServiceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleService1 = ServicePreview(id: UUID(), name: "Online Therapy", price: 100, serviceDescription: "Let's chat over facetime, zoom or gtalk. You pick.", serviceDuration: 60, serviceImage: "mindfultherapy")
        let sampleService2 = ServicePreview(id: UUID(), name: "In-person Therapy", price: 150, serviceDescription: "Meet face to face for a more personal experience.", serviceDuration: 90, serviceImage: "mindfultherapy")

        let context = PersistenceController.shared.container.viewContext

        let service1 = Service(from: sampleService1, context: context)
        let service2 = Service(from: sampleService2, context: context)

        Group {
            ServiceDetailView(service: service1, showDetail: .constant(true))
                .preferredColorScheme(.dark)
            ServiceDetailView(service: service2, showDetail: .constant(true))
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
}
