//
//  NetworkingManager.swift
//  iQuiz
//
//  Created by 이하은 on 5/5/24.
//

import Foundation
import UIKit

class NetworkingManager {
    static let shared = NetworkingManager()

    func fetchQuizzes(completion: @escaping ([Quiz]?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let quizzes = [
                Quiz(title: "Mathematics", description: "Challenges for the numbers wizard!", icon: UIImage(named: "math_icon")!, questions: [
                    Question(text: "What is 2+2?", options: ["3", "4", "5"], correctAnswer: "4"),
                    Question(text: "What is 5x3?", options: ["15", "20", "25"], correctAnswer: "15"),
                    Question(text: "What is 7-2?", options: ["5", "4", "6"], correctAnswer: "5"),
                    Question(text: "What is 14+9?", options: ["17", "12", "23"], correctAnswer: "23")
                ]),
                Quiz(title: "Marvel Super Heroes", description: "Test your knowledge of Marvel Universe!", icon: UIImage(named: "marvel_icon")!, questions: [
                    Question(text: "Who is Iron Man?", options: ["Tony Stark", "Steve Rogers", "Bruce Banner"], correctAnswer: "Tony Stark"),
                    Question(text: "What is Thor's hammer called?", options: ["Mjolnir", "Stormbreaker", "Aesir"], correctAnswer: "Mjolnir"),
                    Question(text: "Who is the god of mischief?", options: ["Thor", "Loki", "Odin"], correctAnswer: "Loki"),
                ]),
                Quiz(title: "Science", description: "Explore the mysteries of science.", icon: UIImage(named: "science_icon")!, questions: [
                    Question(text: "Water is made up of which two elements?", options: ["Oxygen and Hydrogen", "Oxygen and Carbon", "Hydrogen and Nitrogen"], correctAnswer: "Oxygen and Hydrogen"),
                    Question(text: "What planet is known as the Red Planet?", options: ["Mars", "Jupiter", "Saturn"], correctAnswer: "Mars"),
                    Question(text: "What is the chemical symbol for gold?", options: ["Au", "Ag", "Pb"], correctAnswer: "Au"),
                    Question(text: "What gas do plants absorb from the atmosphere?", options: ["Carbon Dioxide", "Nitrogen", "Oxygen"], correctAnswer: "Carbon Dioxide")
                ])
            ]
            DispatchQueue.main.async {
                completion(quizzes)
            }
        }
    }

    func uploadScore(score: Int, forQuiz title: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("Score of \(score) for \(title) uploaded successfully.")
            completion(true)
        }
    }
}
