//
//  ImageDataModel.swift
//  Advait
//
//  Created by Gaurav Sharma on 10/05/24.
//
import Foundation


/// Model to keep Image Data
struct ImageDataModel: Codable, Identifiable {
    let id: String
    let title: String
    let language: String
    let thumbnail: ThumbnailModel
    let mediaType: Int
    let coverageURL: String
    let publishedAt: String
    let publishedBy: String
}
