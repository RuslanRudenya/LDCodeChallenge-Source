//
//  QuestionCollectionViewCell.swift
//  TriviaDB
//
//  Created by RuslanRudenya on 2/6/19.
//

import UIKit

protocol QuestionCellDelegate {
    func didTapTrue(index: Int, sender: UIButton, answerBool: Bool)
    func didTapFalse(index: Int, sender: UIButton, answerBool: Bool)
}

class QuestionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var delegateQuestion: QuestionCellDelegate?
    var index: IndexPath?
    var answeredBool: Bool?
    private let cornerRadius: CGFloat = 11.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupButtons()
    }
    
    
    @IBAction func didTrueButton(_ sender: UIButton) {
        self.delegateQuestion?.didTapTrue(index: (index?.row)!, sender: sender, answerBool: answeredBool!)
    }
    
    @IBAction func didFalseButton(_ sender: UIButton) {
        self.delegateQuestion?.didTapFalse(index: (index?.row)!, sender: sender, answerBool: answeredBool!)
    }
    
    private func setupButtons() {
        var allButtons = [UIButton]()
        allButtons.append(falseButton)
        allButtons.append(trueButton)
        for button in allButtons {
            button.layer.masksToBounds = true
            button.layer.cornerRadius = cornerRadius
            button.layer.borderWidth = 3
            button.layer.borderColor = UIColor.init(red: 83/255, green: 92/255, blue: 169/255, alpha: 1.0).cgColor
        }
    }
    
}
