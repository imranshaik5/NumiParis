//
//  UpcomingModel.swift
//  NumiParis
//
//  Created by imran shaik on 02/04/21.
//

import Foundation
//MARK:- API Response Model
struct UpComingData : Codable {
    let dates : Dates?
    let page : Int?
    let results : [UpcomingResults]?
    let total_pages : Int?
    let total_results : Int?

    enum CodingKeys: String, CodingKey {

        case dates = "dates"
        case page = "page"
        case results = "results"
        case total_pages = "total_pages"
        case total_results = "total_results"
    }
}

struct Dates : Codable {
    let maximum : String?
    let minimum : String?

    enum CodingKeys: String, CodingKey {

        case maximum = "maximum"
        case minimum = "minimum"
    }
}
struct UpcomingResults : Codable {
    let adult : Bool?
    let backdrop_path : String?
    let genre_ids : [Int]?
    let id : Int?
    let original_language : String?
    let original_title : String?
    let overview : String?
    let popularity : Double?
    let poster_path : String?
    let release_date : String?
    let title : String?
    let video : Bool?
    let vote_average : Double?
    let vote_count : Int?

    enum CodingKeys: String, CodingKey {

        case adult = "adult"
        case backdrop_path = "backdrop_path"
        case genre_ids = "genre_ids"
        case id = "id"
        case original_language = "original_language"
        case original_title = "original_title"
        case overview = "overview"
        case popularity = "popularity"
        case poster_path = "poster_path"
        case release_date = "release_date"
        case title = "title"
        case video = "video"
        case vote_average = "vote_average"
        case vote_count = "vote_count"
    }

}

