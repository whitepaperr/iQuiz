//
//  Quiz.swift
//  iQuiz
//
//  Created by 이하은 on 4/30/24.
//

import UIKit

struct Question: Decodable {
    let text: String
    let answers: [String]
    let correctAnswer: String

    enum CodingKeys: String, CodingKey {
        case text
        case answers
        case correctAnswer = "answer"
    }
}

struct Quiz: Decodable {
    let title: String
    let description: String
    let questions: [Question]
    let icon: UIImage?

    enum CodingKeys: String, CodingKey {
        case title
        case description = "desc"
        case questions
        case icon
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        questions = try container.decode([Question].self, forKey: .questions)
        let iconName: String
        switch title {
        case "Science!":
            iconName = "science_icon"
        case "Marvel Super Heroes":
            iconName = "marvel_icon"
        case "Mathematics":
            iconName = "math_icon"
        default:
            iconName = "default_icon"
        }
        icon = UIImage(named: iconName)
    }

}
