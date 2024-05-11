//
//  HomeView.swift
//  Advait
//
//  Created by Gaurav Sharma on 09/05/24.
//

import SwiftUI

struct HomeView: View {
    // Model can be infused as Dependency as well.
    @StateObject private var model = ImageViewModel()
    
    var body: some View {
        ZStack {
            Color(.cyan)
                .edgesIgnoringSafeArea(.all)
            Group {
                if model.isLoading {
                    LoaderView()
                } else {
                    mainView()
                }
            }.onAppear {
                model.fetchImageList()
            }
        }
    }
    
    /// Main Scroll view to display Images in 3 items per row
    /// - Returns: View
    @ViewBuilder func mainView() -> some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 10) {
                ForEach(model.imageModelList, id: \.self) { data in
                    AsyncImageView(url: data.imageURL, id: data.imageID)
                        .frame(width: (UIScreen.main.bounds.width - 40) / 3, height: (UIScreen.main.bounds.width - 40) / 3)
                        .aspectRatio(contentMode: .fill)
                }
            }
            .padding(10)
        }
    }
}

#Preview {
    HomeView()
}
