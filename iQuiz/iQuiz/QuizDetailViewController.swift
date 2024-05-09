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
    private let submitButton = UIButton()
    private var selectedAnswerIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureQuestion()
    }

    private func setupViews() {
        view.backgroundColor = .white
        setupQuestionLabel()
        setupTableView()
        setupSubmitButton()
    }

    private func setupQuestionLabel() {
        view.addSubview(questionLabel)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .center
        questionLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "OptionCell")
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupSubmitButton() {
        view.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = .blue
        submitButton.addTarget(self, action: #selector(handleSubmitButton), for: .touchUpInside)
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func handleSubmitButton() {
        guard let quiz = quiz, let selectedIndex = selectedAnswerIndex else { return }
        let correctAnswerIndex = Int(quiz.questions[currentQuestionIndex].correctAnswer)! - 1
        if selectedIndex == correctAnswerIndex {
            score += 1
            showAlert(message: "Correct!", isLastQuestion: currentQuestionIndex >= quiz.questions.count - 1)
        } else {
            showAlert(message: "Wrong! The correct answer was '\(quiz.questions[currentQuestionIndex].answers[correctAnswerIndex])'.", isLastQuestion: currentQuestionIndex >= quiz.questions.count - 1)
        }
    }

    private func showAlert(message: String, isLastQuestion: Bool) {
        let alert = UIAlertController(title: "Answer", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: isLastQuestion ? "Finish" : "Next", style: .default) { _ in
            if isLastQuestion {
                self.finishQuiz()
            } else {
                self.currentQuestionIndex += 1
                self.configureQuestion()
            }
        })
        present(alert, animated: true, completion: nil)
    }

    private func configureQuestion() {
        guard let quiz = quiz, currentQuestionIndex < quiz.questions.count else { return }
        let currentQuestion = quiz.questions[currentQuestionIndex]
        questionLabel.text = currentQuestion.text
        tableView.reloadData()
    }

    private func finishQuiz() {
        let message = score == quiz?.questions.count ? "Perfect!" : "Almost! Your score: \(score)/\(quiz?.questions.count ?? 0)"
        let alert = UIAlertController(title: "Quiz Completed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true, completion: nil)
    }
}

extension QuizDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quiz?.questions[currentQuestionIndex].answers.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
        cell.textLabel?.text = quiz?.questions[currentQuestionIndex].answers[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAnswerIndex = indexPath.row
    }
}
