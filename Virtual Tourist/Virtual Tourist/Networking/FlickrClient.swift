//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Fauzi Achmad B D on 01/09/21.
//

import Foundation
import UIKit

class FlickrClient {
    
    static let apiKey = "083b89311978688b0641bb14294c0ba5"
    static let keySecret = "a317551829f57e76"
    static let baseURL = "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent"
    static let radius = 30
    static let basePhotoURL = "https://live.staticflickr.com/"
    
    enum Endpoints {
        
        case searchPhotoURL(Double, Double)
        case downloadPhoto(String, String, String)
        
        
        var stringValue: String {
            
            switch self {
            case .searchPhotoURL(let latitude, let longitude):
                
                let pageNum = Int.random(in: 1...5)
                
                return FlickrClient.baseURL + "&api_key=\(FlickrClient.apiKey)" + "&lat=\(latitude)" + "&long=\(longitude)" + "&per_page=18" + "&page=\(pageNum)" + "&format=json&nojsoncallback=1"
            
            case .downloadPhoto(let serverID, let id, let secret):
                
                return FlickrClient.basePhotoURL + "\(serverID)/" + "\(id)_\(secret).jpg"
                
            }
            
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    
    class func getPhotosId(latitude: Double, longitude: Double, completion: @escaping ([PhotoStruct],Error?)->Void){
        
        let url = Endpoints.searchPhotoURL(latitude, longitude).url
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                
                debugPrint("Error fetching data: \(error!)")
                completion([],error)
                
                return
                
            }
            
            let decoder = JSONDecoder()
            
            do {
                
                let responseObj = try decoder.decode(PhotoResponse.self, from: data)
                
                DispatchQueue.main.async {
                    print(responseObj)
                    completion(responseObj.photos.photo,nil)
                }
                
                
            } catch {
                
                debugPrint("Error decoding data")
                completion([],error)
                
            }
            
            
            
        }
        
        task.resume()
        
        
    }
    
    class func getPhotoImage(serverID: String, id: String, secret: String, completion: @escaping (URL?,Error?)->Void){
        
        let photoUrl = FlickrClient.Endpoints.downloadPhoto(serverID, id, secret).url
        
        let task = URLSession.shared.downloadTask(with: photoUrl) { data,response,error in
            
            guard let data = data else {

                completion(nil,error)

                print("Invalid URL")

                return


            }

            print(data)
            
            DispatchQueue.main.async {
                completion(data,nil)
            }
            
            
        }
        
        task.resume()
        
        
    }
    

}
