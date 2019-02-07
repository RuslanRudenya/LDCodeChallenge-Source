//
//  ViewController.swift
//  TriviaDB
//
//  Created by RuslanRudenya on 2/6/19.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var infoSuccsesLabel: UILabel!
    @IBOutlet weak var infoFailerLabel: UILabel!
    
    var questionsArray = [Results]()
    var countSucces: Int = 0
    var countFailer: Int = 0
    var indexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoSuccsesLabel.text = "The number of correct answers: \(countSucces)"
        self.infoFailerLabel.text = "The number of incorrect answers: \(countFailer)"
    }

}

extension ViewController: UICollectionViewDataSource, QuestionCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemQuestion", for: indexPath) as! QuestionCollectionViewCell
        let dataResults = self.questionsArray[indexPath.row]
        cell.questionTitle.text = deleteHTML(questionString: dataResults.question ?? "")
        cell.categoryLabel.text = dataResults.category
        cell.trueButton.setTitle("True", for: .normal)
        cell.falseButton.setTitle("False", for: .normal)
        cell.delegateQuestion = self
        cell.answeredBool = dataResults.isAnswered ?? false
        
        cell.index = indexPath
        self.indexPath = indexPath
        
        if cell.falseButton.isSelected == dataResults.isAnswered ?? false {
            cell.falseButton.setTitleColor(.white, for: .normal)
        }  else {
             cell.falseButton.setTitleColor(.red, for: .normal)
        }
        
        if cell.trueButton.isSelected == dataResults.isAnswered ?? false {
            cell.trueButton.setTitleColor(.white, for: .normal)
        } else {
            cell.falseButton.setTitleColor(.green, for: .normal)
        }
        

        return cell
    }
    
    func didTapTrue(index: Int, sender: UIButton, answerBool: Bool) {
        var dataResult = self.questionsArray[index]
        dataResult.isAnswered = true
        if sender.titleLabel?.text == dataResult.correct_answer {
            createAlert(title: "You're right", text: "You answered correctly", index: index)
            countSucces += 1
            sender.setTitleColor(.red, for: .normal)
        }
        if sender.titleLabel?.text != dataResult.correct_answer {
            createAlert(title: "Wrong answer", text: "You answered incorrectly", index: index)
            countFailer += 1
            sender.setTitleColor(.green, for: .normal)
        }
    
        self.infoSuccsesLabel.text = "The number of correct answers: \(countSucces)"
        self.infoFailerLabel.text = "The number of incorrect answers: \(countFailer)"
    }
    
    func didTapFalse(index: Int, sender: UIButton, answerBool: Bool) {
        var dataResult = self.questionsArray[index]
        dataResult.isAnswered = true
        if sender.titleLabel?.text == dataResult.correct_answer {
            createAlert(title: "You're right", text: "You answered correctly", index: index)
            countSucces += 1
            sender.setTitleColor(.red, for: .normal)
        }
        if sender.titleLabel?.text != dataResult.correct_answer {
            createAlert(title: "Wrong answer", text: "You answered incorrectly", index: index)
            countFailer += 1
            sender.setTitleColor(.green, for: .normal)
        } 
        
        self.infoSuccsesLabel.text = "The number of correct answers: \(countSucces)"
        self.infoFailerLabel.text = "The number of incorrect answers: \(countFailer)"
        
    }
    
    private func deleteHTML(questionString: String) -> String? {
        let dataHtml = NSString(string: questionString).data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
            NSAttributedString.DocumentType.html]
        guard let attributedString = try? NSMutableAttributedString(data: dataHtml ?? Data(), options: options, documentAttributes: nil) else { return nil }
        return attributedString.string
    }
    
    private func createAlert(title: String, text: String, index: Int) {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let buttonOk = UIAlertAction(title: "OK", style: .default) { [weak self] (alertAction) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {[weak self] in
                guard let weakSelf = self else {return}
                var results = self?.questionsArray[index]
                results!.isAnswered = true
                
                var rowIndex = index
                let numberOfrecords: Int = weakSelf.questionsArray.count - 1
                if rowIndex < numberOfrecords {
                    rowIndex = rowIndex + 1
                } else {
                    self?.countSucces = 0
                    self?.countFailer = 0
                    self?.infoSuccsesLabel.text = "The number of correct answers: \(self?.countSucces ?? 0)"
                    self?.infoFailerLabel.text = "The number of incorrect answers: \(self?.countFailer ?? 0)"
                    rowIndex = 0
                }
                
                weakSelf.collectionView.scrollToItem(at: IndexPath(row: rowIndex, section: 0), at: .centeredHorizontally, animated: true)
                
                
            }
        }
        
        alertController.addAction(buttonOk)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    private func getIndexPathForFirstUnansweredQuestion() -> IndexPath {
        for index in 0..<questionsArray.count {
            if (questionsArray[index].isAnswered ?? true) {
                return IndexPath(row: index, section: 0)
            }
        }
        return IndexPath(row: questionsArray.count, section: 0)
    }
    

}

extension ViewController: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
         let indexPath = self.getIndexPathForFirstUnansweredQuestion()

        if let attributes = self.collectionView.layoutAttributesForItem(at: indexPath), indexPath.item != self.questionsArray.count {
            let lastPoint = CGPoint(x: attributes.center.x - scrollView.bounds.size.width * 0.5, y: scrollView.contentOffset.y)

            if scrollView.contentOffset.x < lastPoint.x {
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
   }
}





