//
//  FAQAPIResponse.swift
//  IdrisCar
//
//  Created by Amir Ahmed on 18/06/2025.
//

import Foundation

// MARK: - FAQAPIResponse
struct FAQAPIResponse: Codable {
    let id: Int
    let name: String
    let image: String?
    let description: String?
    let questionsAnswers: [QuestionsAnswer]

    enum CodingKeys: String, CodingKey {
        case id, name, image, description
        case questionsAnswers = "questions_answers"
    }
}

extension FAQAPIResponse: Equatable {}

// MARK: - QuestionsAnswer
struct QuestionsAnswer: Codable {
    let question, answer: String
}

extension QuestionsAnswer: Equatable {}
