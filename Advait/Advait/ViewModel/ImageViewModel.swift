//
//  ImageViewModel.swift
//  Advait
//
//  Created by Gaurav Sharma on 09/05/24.
//

import Foundation
import SwiftUI
import CoreData

/// Enum for URL constant
private enum URLConstant {
    static let imageDataURL = "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100"
}

// Protocol for fetching the data from URL
protocol ImageModelProvider {
    func fetchImageList()
}


class ImageViewModel: ObservableObject, ImageModelProvider {
    @Published var isLoading: Bool = false
    var imageDataList =  [ImageDataModel]()
    let netWorkManager = NetworkManager()

    var imageModelList = [ImageModel]()
    
    private let managedObjectContext = PersistenceController.shared.container.viewContext
    
    
    /// Method fetches the ImageData from Server
    /// If we already have imageData, we fetch images from the Document Directory
    /// If we dont have , we fetch from the server and save to Document Directory
    /// We save imageURL and imageID in Database
    func fetchImageList() {
        isLoading = true
        // Check if images are already saved in the database
        if fetchImageDataListFromDataBase() > 0 {
            isLoading = false
        } else {
            if let url = URL(string: URLConstant.imageDataURL) {
                netWorkManager.fetchDataFromTypicalNetworkManager(url: url) { [weak self] (result: Result<[ImageDataModel], Error>) in
                    guard let _self = self  else { return }
                    switch result {
                    case .success(let imageDataList):
                        _self.imageDataList = imageDataList
                        _self.processAndSaveImageDataToDataBase(imageData: _self.imageDataList)
                    case .failure(let error):
                        print("The error received is == \(error.localizedDescription)")
                    }
                    _self.isLoading = false
                }
            }
        }
    }
    
    
    /// To get the ImageData Count from the DB, so we dont need to make API Call again
    /// - Returns: Image Data Count
    func fetchImageDataListFromDataBase() -> Int {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
       
        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            for data in result {
                let imageModel = ImageModel(imageID: data.imageID ?? "", imageURL: data.imageName ?? "")
                self.imageModelList.append(imageModel)
            }
        } catch {
            print("Error fetching image name from CoreData:", error)
        }
        
        return self.imageModelList.count
    }
    
    
    /// This method saves the API response data to Database as well
    /// we cache the data in local array
    /// - Parameter imageData: Data received from the server
    func processAndSaveImageDataToDataBase(imageData: [ImageDataModel]) {
        for data in imageData {
            let userImageModel = User(context: managedObjectContext)
            userImageModel.imageID = data.thumbnail.id
            userImageModel.imageName = data.thumbnail.domain + "/" + data.thumbnail.basePath + "/0/" + data.thumbnail.key
            
            let imageModel = ImageModel(imageID: userImageModel.imageID ?? "", imageURL: userImageModel.imageName ?? "")
            self.imageModelList.append(imageModel)
            
            do {
                try managedObjectContext.save()
                print("Image data saved to CoreData")
            } catch {
                print("Error saving image data to CoreData:", error)
            }
        }
    }
}
