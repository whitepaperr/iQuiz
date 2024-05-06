//
//  Quiz.swift
//  iQuiz
//
//  Created by 이하은 on 4/30/24.
//

import UIKit

struct Question {
    let text: String
    let options: [String]
    let correctAnswer: String
}

struct Quiz {
    let title: String
    let description: String
    let icon: UIImage
    let questions: [Question]
}
