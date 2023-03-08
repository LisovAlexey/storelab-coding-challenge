//
//  ContentView.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 06/03/2023.
//

import SwiftUI

class FavouritesImagesStore: ObservableObject {
    @Published var isFavouriteSet: Set<Int> = []
}

struct MainView: View {

    @StateObject var imageInfoLoader = ImageInfoLoader(
        imageInfoStore:
            ImageInfoStoreService(context: PersistenceController.shared.container.newBackgroundContext()),
        favouritesStore: ImageInfoStoreServiceUserDefaults()
    )

    @StateObject var favouritesImagesStore = FavouritesImagesStore()

    var body: some View {
        TabView {
            ImageGridView()
                .tabItem {
                    Label("API", systemImage: "list.dash")
                }

            FavouritesView()
                .tabItem {
                    Label("Favourites", systemImage: "heart")
                }
        }
        .environmentObject(imageInfoLoader)
        .environmentObject(favouritesImagesStore)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
