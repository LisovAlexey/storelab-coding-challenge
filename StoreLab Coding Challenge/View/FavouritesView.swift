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
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 2), GridItem(.flexible(), spacing: 2)], spacing: 2) {
                    ForEach(imageInfoLoader.favourites.indices, id: \.self) { index in
                        let imageInfo = imageInfoLoader.favourites[index]

                        ImageView(imageInfo: imageInfo)
                    }
                }
            }
        }
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}
