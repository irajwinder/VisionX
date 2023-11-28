//
//  Photo.swift
//  VisionX
//
//  Created by Rajwinder Singh on 11/21/23.
//

import Foundation

struct Photo: Codable {
    let id: Int
    let url: String
    let src: PhotoSource
}

struct PhotoSource: Codable {
    let original: String
    let tiny: String
}

struct PhotoResponse: Codable {
    let page: Int
    let per_page: Int
    let photos: [Photo]
    let total_results: Int
    let next_page: String?
}
