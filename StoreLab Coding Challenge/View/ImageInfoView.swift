//
//  ImageInfoView.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 07/03/2023.
//

import SwiftUI

struct Cell: View {
    var description: String
    var value: String

    var body: some View {
        HStack {
            Text(description)
            Spacer()
            Text(value)
        }
    }
}

struct ImageInfoView: View {
    var imageInfo: ImageInfo

    var body: some View {

        VStack {
            Text("Image info").font(.title3)

            List {
                Cell(description: "ID", value: "\(imageInfo.id)")
                Cell(description: "Author", value: "\(imageInfo.author)")
                Cell(description: "Width", value: "\(imageInfo.width)")
                Cell(description: "Height", value: "\(imageInfo.height)")
                Cell(description: "Original", value: "\(imageInfo.url)")
            }
        }.padding()

    }
}

struct ImageInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ImageInfoView(imageInfo: ImageInfo.mock)
    }
}
