//
//  QuizDataSource.swift
//  iQuiz
//
//  Created by 이하은 on 4/30/24.
//

import UIKit

class QuizDataSource: NSObject, UITableViewDataSource {
    var quizzes: [Quiz] = []

    func update(quizzes: [Quiz]) {
        self.quizzes = quizzes
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath) as? QuizTableViewCell else {
            return UITableViewCell()
        }
        let quiz = quizzes[indexPath.row]
        cell.configure(with: quiz)
        return cell
    }
}
