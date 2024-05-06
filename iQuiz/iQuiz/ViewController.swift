//
//  ViewController.swift
//  iQuiz
//
//  Created by 이하은 on 4/30/24.
//

import UIKit

class ViewController: UIViewController {
    private var tableView = UITableView()
    private var dataSource: QuizDataSource?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupToolbar()
        fetchQuizzes()
    }

    private func fetchQuizzes() {
        NetworkingManager.shared.fetchQuizzes { [weak self] quizzes in
            guard let self = self, let quizzes = quizzes else { return }
            DispatchQueue.main.async {
                self.dataSource = QuizDataSource(quizzes: quizzes)
                self.tableView.dataSource = self.dataSource
                self.tableView.reloadData()
            }
        }
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self.dataSource
        tableView.register(QuizTableViewCell.self, forCellReuseIdentifier: "QuizCell")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupToolbar() {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbar)

        let settingsItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(showSettings))
        toolbar.setItems([settingsItem], animated: false)

        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func showSettings() {
        let alertController = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let quiz = dataSource?.quizzes[indexPath.row] else { return }
        let detailVC = QuizDetailViewController()
        detailVC.quiz = quiz
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
