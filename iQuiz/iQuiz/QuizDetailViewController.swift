//
//  QuizDetailViewController.swift
//  iQuiz
//
//  Created by 이하은 on 5/5/24.
//

import UIKit

class QuizDetailViewController: UIViewController {
    var quiz: Quiz?
    private var currentQuestionIndex = 0
    private var score = 0
    private let questionLabel = UILabel()
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureQuestion()
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(questionLabel)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .center
        questionLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "OptionCell")

        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func configureQuestion() {
        guard let quiz = quiz, currentQuestionIndex < quiz.questions.count else {
            finishQuiz()
            return
        }
        let currentQuestion = quiz.questions[currentQuestionIndex]
        questionLabel.text = currentQuestion.text
        tableView.reloadData()
    }

    private func finishQuiz() {
        let alertController = UIAlertController(title: "Quiz Completed", message: "Your score: \(score)/\(quiz?.questions.count ?? 0)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.uploadScore()
        })
        present(alertController, animated: true, completion: nil)
    }

    private func uploadScore() {
        NetworkingManager.shared.uploadScore(score: score, forQuiz: quiz?.title ?? "") { success in
            print("Score uploaded successfully")
            self.navigationController?.popViewController(animated: true)
        }
    }

    private func answerChosen(_ answer: String) {
        guard let currentQuestion = quiz?.questions[currentQuestionIndex] else { return }
        if answer == currentQuestion.correctAnswer {
            score += 1
        }
        currentQuestionIndex += 1
        if currentQuestionIndex < quiz?.questions.count ?? 0 {
            configureQuestion()
        } else {
            finishQuiz()
        }
    }
}

extension QuizDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let quiz = quiz, currentQuestionIndex < quiz.questions.count else { return 0 }
        return quiz.questions[currentQuestionIndex].answers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
        cell.textLabel?.text = quiz?.questions[currentQuestionIndex].answers[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedOption = quiz?.questions[currentQuestionIndex].answers[indexPath.row]
        if let selectedOption = selectedOption {
            answerChosen(selectedOption)
        }
    }
}
