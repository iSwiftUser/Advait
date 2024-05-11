//
//  AsyncImageView.swift
//  Advait
//
//  Created by Gaurav Sharma on 10/05/24.
//

import SwiftUI

struct AsyncImageView: View {
    @StateObject private var imageLoader: ImageLoader
        
    init(url: String, id:String) {
            _imageLoader = StateObject(wrappedValue: ImageLoader(url: url, imageID: id))
        }
        
        var body: some View {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
            }
        }
}

#Preview {
    AsyncImageView(url: "https://cimg.acharyaprashant.org/images/img-f92c4193-2483-4ab7-aefd-854f022d81a8/0/image.jpg", id: "")
}
