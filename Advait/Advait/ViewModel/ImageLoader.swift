//
//  ImageLoader.swift
//  Advait
//
//  Created by Gaurav Sharma on 10/05/24.
//

import Foundation
import UIKit
import CoreData

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let path: String
    private let imageID: String
    private let managedObjectContext = PersistenceController.shared.container.viewContext
    
    init(url: String, imageID: String) {
        self.path = url
        self.imageID = imageID
        loadImage()
    }
    
    private func loadImage() {
        // Load image from Document Directory based on the image name
        // If image exists in the Document Directory , it wil be loaded
        // Else We will make an API call to fetch the image.
        /// Also the use case , where few images were downloaded and user kills the app,
        /// Then next time, it will fetch the remaining images from the URL/Path passed
        /// as argument and saves them to Document Directory
        if let imageData = loadImageDataFromDocumentDirectory(imageID: self.imageID) {
            self.image = UIImage(data: imageData)
            return
        }
        
        guard let url = URL(string: self.path) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
                
                // Save the image data to Document Directory
                self.saveImageDataToDocumentDirectory(data: data, imageID: self.imageID)
            }
        }.resume()
    }
    
    
    /// Saves the image Data to Document directory
    /// - Parameters:
    ///   - data: Data received from the server
    ///   - imageID: Image ID received from server
    private func saveImageDataToDocumentDirectory(data: Data, imageID: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let imageName = imageID + ".jpg"
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        
        do {
            try data.write(to: fileURL)
            print("Image saved to: \(fileURL)")
        } catch {
            print("Error saving image:", error)
        }
    }

    
    /// Loads the image from the local document directory
    /// - Parameter imageID: image ID of the image to be retrieved
    /// - Returns: Image Data
    private func loadImageDataFromDocumentDirectory(imageID: String) -> Data? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let imageName = imageID + ".jpg"
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else  {
            return nil
        }
        
        do {
            let imageData = try Data(contentsOf: fileURL)
            return imageData
        } catch {
            print("Error loading image:", error)
            return nil
        }
    }
}

