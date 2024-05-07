//
//  SettingsViewController.swift
//  iQuiz
//
//  Created by 이하은 on 5/6/24.
//

import UIKit

class SettingsViewController: UIViewController {
    var urlTextField: UITextField!
    var checkNowButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = .white

        urlTextField = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
        urlTextField.borderStyle = .roundedRect
        urlTextField.placeholder = "Enter Quiz URL"
        urlTextField.text = UserDefaults.standard.string(forKey: "QuizURL") ?? "http://tednewardsandbox.site44.com/questions.json"
        view.addSubview(urlTextField)

        checkNowButton = UIButton(frame: CGRect(x: 20, y: 150, width: 300, height: 40))
        checkNowButton.setTitle("Check Now", for: .normal)
        checkNowButton.backgroundColor = .blue
        checkNowButton.addTarget(self, action: #selector(checkNowTapped), for: .touchUpInside)
        view.addSubview(checkNowButton)
    }

    @objc func checkNowTapped() {
        guard let urlString = urlTextField.text, let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        UserDefaults.standard.set(urlString, forKey: "QuizURL")
        UserDefaults.standard.synchronize()

        NetworkingManager.shared.fetchQuizzes(from: url) { [weak self] quizzes in
            DispatchQueue.main.async {
                if quizzes != nil {
                    print("Quizzes updated successfully.")
                    NotificationCenter.default.post(name: NSNotification.Name("QuizzesUpdated"), object: nil)
                    self?.dismiss(animated: true, completion: nil)
                } else {
                    print("Failed to fetch quizzes.")
                    let alert = UIAlertController(title: "Error", message: "Could not load quizzes from the specified URL.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
