//
//  ImageGridView.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 06/03/2023.
//

import SwiftUI
import NukeUI

struct ImageGridView: View {

    @EnvironmentObject var imageInfoLoader: ImageInfoLoader

    @State var isDisplayingPreview = false
    @State var selected: ImageInfo?

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 2), GridItem(.flexible(), spacing: 2)], spacing: 2) {
                ForEach(imageInfoLoader.imageInfos.indices, id: \.self) { index in
                    let imageInfo = imageInfoLoader.imageInfos[index]

                    ImageView(imageInfo: imageInfo)
                        .onAppear {
                            Task {
                                try await imageInfoLoader.loadImagesIfNeeded(imageInfo: imageInfo)
                            }
                        }

                        .onTapGesture(count: 2) {
                            Task {
                                await imageInfoLoader.addToFavourite(id: imageInfo.id)
                            }
                        }
                        .onTapGesture {
                            selected = imageInfo
                        }
                        
                        .overlay(
                            imageInfoLoader.favourites.contains(where: {$0.id == imageInfo.id}) ?
                            ZStack {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                                    .font(.title)
                                Image(systemName: "heart")
                                    .foregroundColor(.black)
                                    .font(.title)
                            }
                                 : nil,
                            alignment: .topTrailing)
                        }
                }
            }
            .padding(0)
            .onAppear {
                Task {
                    do {
                        try await imageInfoLoader.loadImages()
                    } catch {
                        fatalError("can't load images; \(error.localizedDescription)" )
                    }

                }
            }
        .sheet(isPresented: $isDisplayingPreview, onDismiss: {
            selected = nil
        }, content: {
            if let selected = selected {
                ImageInfoView(imageInfo: selected)
            }
        })
        .onChange(of: selected) { newValue in
            isDisplayingPreview = newValue != nil
        }
    }
}

struct ImageGridView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGridView()
    }
}
