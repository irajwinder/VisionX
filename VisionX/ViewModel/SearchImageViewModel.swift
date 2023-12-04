//
//  SearchImageViewModel.swift
//  VisionX
//
//  Created by Rajwinder Singh on 12/3/23.
//

import Foundation

class SearchImageViewModel {
    var photos: [Photo] = []
    var response: PhotoResponse?
    var query: String = ""
    var currentPage: Int = 1
    var perPage: Int = 0
    var totalPages: Int = 0
}
