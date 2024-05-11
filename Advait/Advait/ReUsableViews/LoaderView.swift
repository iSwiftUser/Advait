//
//  LoaderView.swift
//  Advait
//
//  Created by Gaurav Sharma on 10/05/24.
//

import SwiftUI

struct LoaderView: View {
    var body: some View {
        ProgressView("Loading in Progress...")
            .font(.title3)
            .bold()
            .italic()
            .fontDesign(.serif)
    }
}

#Preview {
    LoaderView()
}
