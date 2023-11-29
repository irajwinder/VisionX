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
    let video_files: [VideoFile]
    let video_pictures: [VideoPicture]
}

struct VideoFile: Codable {
    let id: Int
    let fps: Float
    let link: String
}

struct VideoPicture: Codable {
    let id: Int
    let nr: Int
    let picture: String
}

struct VideoResponse: Codable {
    let page: Int
    let per_page: Int
    let videos: [Video]
    let total_results: Int
    let next_page: String
    let url: String
}


//struct VideoResponse: Codable {
//    let page: Int
//    let per_page: Int
//    let videos: [Video]
//    let total_results: Int
//    let next_page: String
//    let url: String
//}
//
//struct Video: Codable {
//    let id: Int
//    let width: Int
//    let height: Int
//    let duration: Int
//    let full_res: String?
//    let tags: [String]
//    let url: String
//    let image: String
//    let avg_color: String?
//    let user: User
//    let video_files: [VideoFile]
//    let video_pictures: [VideoPicture]
//}
//
//struct User: Codable {
//    let id: Int
//    let name: String
//    let url: String
//}
//
//struct VideoFile: Codable {
//    let id: Int
//    let quality: String
//    let file_type: String
//    let width: Int
//    let height: Int
//    let fps: Double
//    let link: String
//}
//
//struct VideoPicture: Codable {
//    let id: Int
//    let nr: Int
//    let picture: String
//}
