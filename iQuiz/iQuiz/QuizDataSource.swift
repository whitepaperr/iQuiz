//
//  QuizDataSource.swift
//  iQuiz
//
//  Created by 이하은 on 4/30/24.
//

import UIKit

class QuizDataSource: NSObject, UITableViewDataSource {
    var quizzes: [Quiz]

    init(quizzes: [Quiz]) {
        self.quizzes = quizzes
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath) as! QuizTableViewCell
        let quiz = quizzes[indexPath.row]
        cell.configure(with: quiz)
        return cell
    }
}
