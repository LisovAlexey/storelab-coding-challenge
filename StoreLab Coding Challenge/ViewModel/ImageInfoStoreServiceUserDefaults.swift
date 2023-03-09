//
//  ImageInfoStoreServiceUserDefaults.swift
//  StoreLab Coding Challenge
//
//  Created by Alexey Lisov on 08/03/2023.
//

//import Foundation
//
//enum LoadingDataError: Error {
//    case decodingError
//}
//
//struct ImageInfoStoreServiceUserDefaults {
//    private let userDefaults: UserDefaults
//    private let key = "imageInfos"
//    
//    init(userDefaults: UserDefaults = UserDefaults.standard) {
//        self.userDefaults = userDefaults
//    }
//}
//
//extension ImageInfoStoreServiceUserDefaults: ImageInfoStore {
//    func save(imageInfos: [ImageInfo]) throws {
//        
//        let encoder = JSONEncoder()
//        if let encoded = try? encoder.encode(imageInfos) {
//            userDefaults.set(encoded, forKey: key)
//            return
//        }
//        
//        print("Favourites not saved")
//        
//    }
//    
//    func load() throws -> [ImageInfo] {
//        
//        if let encodedData = userDefaults.object(forKey: key) as? Data {
//            
//            let decoder = JSONDecoder()
//            
//            if let decoded = try? decoder.decode([ImageInfo].self, from: encodedData) {
//                print("Favourites decoded")
//                return decoded
//            }
//                
//        }
//        
//        print("Favourites image info can't be decoded")
//        throw LoadingDataError.decodingError
////        fatalError("Image info can't be decoded")
//        
//    }
//}
