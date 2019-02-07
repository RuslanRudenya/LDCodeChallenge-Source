//
//  LoadingScreenVC.swift
//  TriviaDB
//
//  Created by RuslanRudenya on 2/7/19.
//

import UIKit

class LoadingScreenVC : UIViewController {
    
    @IBOutlet private weak var progressView: UIProgressView!
    private var questionsArr = [Results]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkingService.shared.getData { (response) in
            self.questionsArr = response.results
        }
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
        progressView.setProgress(0, animated: false)
        
    }
    
    @objc private func updateProgressView() {
        if progressView.progress != 1 {
            self.progressView.progress += 2 / 10
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuestionsViewController") as! ViewController
            vc.questionsArray = questionsArr
            self.present(vc, animated: false, completion: nil)
            self.progressView.isHidden = true
        }
    }
}
