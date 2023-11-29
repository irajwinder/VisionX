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
    let video_files: [VideoFile]
    let video_pictures: [VideoPicture]
}

struct VideoFile: Codable {
    let id: Int
    let link: String
}

struct VideoPicture: Codable {
    let id: Int
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
