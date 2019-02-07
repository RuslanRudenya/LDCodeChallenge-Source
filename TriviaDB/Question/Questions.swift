//
//  Question.swift
//  TriviaDB
//
//  Created by RuslanRudenya on 2/6/19.
//

import CoreData

struct Question: Codable {
    var response_code: Int
    var results: [Results]
}

struct Results: Codable {
     var category: String?
     var type: String?
     var difficulty: String?
     var question: String?
     var correct_answer: String?
     var incorrect_answers: [String]?
     var isAnswered: Bool?
 
}


    
