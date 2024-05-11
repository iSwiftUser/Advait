//
//  ThumbnailModel.swift
//  Advait
//
//  Created by Gaurav Sharma on 10/05/24.
//

import Foundation


/// Model to keep thumbnail object
struct ThumbnailModel: Codable, Identifiable {
    let id: String
    let version: Int
    let domain: String
    let basePath: String
    let key: String
    let qualities: [Int]
    let aspectRatio: Double
}
