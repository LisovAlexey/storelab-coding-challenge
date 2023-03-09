//
//  ImageView.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 06/03/2023.
//

import SwiftUI
import NukeUI

struct ImageView: View {
    @State var imageInfo: ImageInfo

    var body: some View {
        VStack {
            if let image = imageInfo.image {
                Image(uiImage: image) // UIImage(data: imageData)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
//            Text("\(imageInfo.id)")
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(imageInfo: ImageInfo.mock)
    }
}
