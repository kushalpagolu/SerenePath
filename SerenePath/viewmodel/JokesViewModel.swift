//
//  JokesViewModel.swift
//  VoiceTherapy
//
//  Created by Kushal P on 3/27/23.
//

import Foundation
import Combine
import SwiftUI

class JokesViewModel: ObservableObject {
    @Published var joke: String = ""
    private var cancellables = Set<AnyCancellable>()

    func fetchJoke() {
        let url = URL(string: "http://127.0.0.1:5000/get-joke")!
        fetchData(from: url)
            .retry(2) // Number of retries
            .map { data -> String? in
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any], let joke = jsonResponse["joke"] as? String {
                    return joke
                }
                return nil
            }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] joke in
                if let joke = joke {
                    self?.joke = joke
                } else {
                    // Handle the case when the joke could not be fetched after retries
                    self?.joke = "Oops! We couldn't fetch a joke. Please try again."
                }
            }
            .store(in: &cancellables)
    }

    private func fetchData(from url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError { _ in FetchJokeError.networkError }
            .eraseToAnyPublisher()
    }
}

enum FetchJokeError: Error {
    case networkError
}
