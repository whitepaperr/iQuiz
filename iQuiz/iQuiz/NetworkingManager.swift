//
//  NetworkingManager.swift
//  iQuiz
//
//  Created by 이하은 on 5/5/24.
//

import Foundation

class NetworkingManager {
    static let shared = NetworkingManager()
    private var quizURL = UserDefaults.standard.string(forKey: "QuizURL") ?? "http://tednewardsandbox.site44.com/questions.json"

    func fetchQuizzes(from url: URL, completion: @escaping ([Quiz]?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching quizzes: \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            do {
                let quizzes = try JSONDecoder().decode([Quiz].self, from: data)
                completion(quizzes)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }

    func setQuizURL(newURL: String) {
        UserDefaults.standard.set(newURL, forKey: "QuizURL")
        UserDefaults.standard.synchronize()
        quizURL = newURL
    }

    func uploadScore(score: Int, forQuiz title: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("Score of \(score) for \(title) uploaded successfully.")
            completion(true)
        }
    }
}
