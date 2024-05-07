//
//  ViewController.swift
//  iQuiz
//
//  Created by 이하은 on 4/30/24.
//

import UIKit

class ViewController: UIViewController {
    private var tableView = UITableView()
    private var dataSource = QuizDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(showSettings))
        setupTableView()
        fetchQuizzes()
    }

    private func fetchQuizzes() {
        let urlString = UserDefaults.standard.string(forKey: "QuizURL") ?? "http://tednewardsandbox.site44.com/questions.json"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        NetworkingManager.shared.fetchQuizzes(from: url) { [weak self] quizzes in
            guard let self = self, let quizzes = quizzes else {
                print("Failed to fetch quizzes or no quizzes found")
                return
            }
            DispatchQueue.main.async {
                self.dataSource.update(quizzes: quizzes)
                self.tableView.reloadData()
            }
        }
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(QuizTableViewCell.self, forCellReuseIdentifier: "QuizCell")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc private func showSettings() {
        let settingsVC = SettingsViewController()
        settingsVC.modalPresentationStyle = .popover
        settingsVC.preferredContentSize = CGSize(width: 320, height: 200)
        if let popoverController = settingsVC.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem
        }
        present(settingsVC, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quiz = dataSource.quizzes[indexPath.row]
        let detailVC = QuizDetailViewController()
        detailVC.quiz = quiz
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
