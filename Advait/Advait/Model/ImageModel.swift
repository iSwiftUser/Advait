//
//  ImageModel.swift
//  Advait
//
//  Created by Gaurav Sharma on 11/05/24.
//

import Foundation

/// A simple model to keep image Data attributes
struct ImageModel: Codable, Hashable {
    let imageID: String
    let imageURL: String
}
