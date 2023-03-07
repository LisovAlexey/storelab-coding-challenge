//
//  ImageGridView.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 06/03/2023.
//

import SwiftUI
import NukeUI



struct ImageGridView: View {
    
    @StateObject var imageInfoLoader = ImageInfoLoader()
    
    @State var isDisplayingPreview = false
    @State var selected: ImageInfo?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 4), GridItem(.flexible(), spacing: 4)], spacing: 4) {
                ForEach(imageInfoLoader.imageInfos) { imageInfo in
                    Button(action: {
                        selected = imageInfo
                        isDisplayingPreview = true
                    }, label: {
                        ImageView(imageInfo: imageInfo)
                            .onAppear {
                                Task {
                                    try await imageInfoLoader.loadImagesIfNeeded(imageInfo: imageInfo)
                                }
                            }
                    })
                }
            }
            .padding(8)
            .onAppear {
                Task {
                    try? await imageInfoLoader.loadImages()
                }
            }
        }
        .sheet(isPresented: $isDisplayingPreview, onDismiss: {
            selected = nil
            isDisplayingPreview = false
        }, content: {
            if let selected = selected {
                ImageInfoView(imageInfo: selected)
            }
        })
    }
}


struct ImageGridView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGridView()
    }
}



//class ImageInfoLoader: ObservableObject {
//
//    @Published var imageInfos: [ImageInfo] = []
//    @Published var page = 0
//
//    var limit = 20
//    let downloadBefore = 20

//    var isInited = false
//    private var loadingNow = false

//    func initiallyLoadData() {
//        isInited = true
//        loadMoreData()
//    }

//    func loadMoreDataIfNeeded(currentItem: ImageInfo) {
//        guard imageInfos.count >= downloadBefore && isInited else {
//            return
//        }
//
//        guard let lastDownloadBeforeItem = imageInfos.suffix(downloadBefore).first else {
//            return
//        }
//
//        if currentItem.id >= lastDownloadBeforeItem.id && !loadingNow {
//            loadMoreData()
//        } else {
//            print(currentItem.id)
//        }
//    }
//
//    func loadMoreData() {
//
//        loadingNow = true
////        do {
//            Task {
//                page += 1
//                var nextImageInfoList: [ImageInfo] =
//                    try await requestManager.perform(PhotoInfoListRequest.getPhotoInfoListById(page: page, limit: limit))
//
//                let datas = await withTaskGroup(of: Data.self) { [unowned self] group in
//
//                    for imageInfo in nextImageInfoList {
//
//                        group.addTask {
//                            let request = PhotoRequest.getPhotoByIdSquare(id: imageInfo.id, squareSize: 400)
//
//                            do {
//                                return try await requestManager.apiManager.perform(request)
//                            } catch {
//                                print("fail1")
//                            }
//
//                            return Data()
//                        }
//                    }
//                }
//
//                for (i, data) in nextImageInfoList.enumerated() {
//                    nextImageInfoList[i] = data
//                }
//
//                await MainActor.run {
//                    self.imageInfos.append(contentsOf: nextImageInfoList)
//                }
//
//
//            }
//
////            imageInfos.append(contentsOf: nextImageInfoList)
//
//
////            print("New images loaded; page: ", page)
////        } catch {
////            print("Error getting new image: \(error.localizedDescription)")
////        }
//
//        loadingNow = false
//
//    }
//
//}
