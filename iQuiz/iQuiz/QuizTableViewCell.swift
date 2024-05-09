//
//  QuizTableViewCell.swift
//  iQuiz
//
//  Created by 이하은 on 4/30/24.
//

import UIKit

class QuizTableViewCell: UITableViewCell {
    private var quizIconImageView = UIImageView()
    private var quizTitleLabel = UILabel()
    private var quizDescriptionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(quizIconImageView)
        addSubview(quizTitleLabel)
        addSubview(quizDescriptionLabel)

        quizIconImageView.translatesAutoresizingMaskIntoConstraints = false
        quizTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        quizDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        quizTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        quizDescriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        NSLayoutConstraint.activate([
            quizIconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            quizIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            quizIconImageView.widthAnchor.constraint(equalToConstant: 50),
            quizIconImageView.heightAnchor.constraint(equalToConstant: 50),

            quizTitleLabel.leadingAnchor.constraint(equalTo: quizIconImageView.trailingAnchor, constant: 10),
            quizTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            quizTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),

            quizDescriptionLabel.leadingAnchor.constraint(equalTo: quizIconImageView.trailingAnchor, constant: 10),
            quizDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            quizDescriptionLabel.topAnchor.constraint(equalTo: quizTitleLabel.bottomAnchor, constant: 5),
            quizDescriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }

    func configure(with quiz: Quiz) {
        quizIconImageView.image = quiz.icon
        quizTitleLabel.text = quiz.title
        quizDescriptionLabel.text = quiz.description
    }
}
