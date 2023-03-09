//
//  FavouritesView.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 08/03/2023.
//

import SwiftUI

struct FavouritesView: View {

    @EnvironmentObject var imageInfoLoader: ImageInfoLoader

    var body: some View {

        if imageInfoLoader.favourites.isEmpty {
            Text("There are no fav images! Long tap to like image")
        } else {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 4), GridItem(.flexible(), spacing: 4)], spacing: 4) {
                    ForEach(imageInfoLoader.favourites.indices, id: \.self) { index in
                        let imageInfo = imageInfoLoader.favourites[index]

                        ImageView(imageInfo: imageInfo)
                    }
                }
            }
            .padding(8)
        }
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}
