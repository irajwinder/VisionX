//
//  Video.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/22/23.
//

import Foundation

struct Video: Codable {
    let id: Int
    let duration: Int
    let url: String
    let image: String
   // let videoFiles: [VideoFile]
//    let videoPictures: [VideoPicture]
}

//struct VideoFile: Codable {
//    let id: Int
//    let quality: String
//    let fileType: String
//    let width: Int
//    let height: Int
//    let fps: Float
//    let link: String
//}

//struct VideoPicture: Codable {
//    let id: Int
//    let nr: Int
//    let picture: String
//}

struct VideoResponse: Codable {
    let page: Int
    let perPage: Int
    let videos: [Video]
    let totalResults: Int
    let nextPage: String
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case page, perPage = "per_page", videos, totalResults = "total_results", nextPage = "next_page", url
    }
}