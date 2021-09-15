//
//  OTMClient.swift
//  On The Map
//
//  Created by Fauzi Achmad B D on 22/08/21.
//

import Foundation

class OTMClient {
    
    struct Auth {
        
        static var sessionId: String? = nil
        static var key = ""
        static var firstName = ""
        static var lastName = ""
        static var objectId = ""
        
    }
    
    enum Endpoints {
        
        static let baseURL = "https://onthemap-api.udacity.com/v1"
        
        case getStudentsLocation(Int)
        case userLogin
        case userLogout
        case getUserData
        case addUserLocation
        
        var stringValue: String {
            
            switch self {
            
            case .userLogin:
                return Endpoints.baseURL + "/session"
            
            case .userLogout:
                return Endpoints.baseURL + "/session"
            
            case .getUserData:
                return Endpoints.baseURL + "/users/"+Auth.key
                
            case .getStudentsLocation(let limit):
                return Endpoints.baseURL + "/StudentLocation?limit=\(limit)&order=-updatedAt"
            
            case .addUserLocation:
                return Endpoints.baseURL + "/StudentLocation"
                

            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
        
    }
    
    class func addUserLocation(location: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool,Error?)->Void){
        
        // var request = URLRequest(url: OTMClient.Endpoints.addUserLocation.url)
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = """
            {\"uniqueKey\": \"1234\", \"firstName\": \"Jon\", \"lastName\": \"Tomang\",\"mapString\": \"\(location)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}
            """.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                print(error)
                completion(false,error)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let responseObj = try decoder.decode(AddUserLocationResponseModel.self, from: data)
                Auth.objectId = responseObj.objectId
                
                DispatchQueue.main.async {
                    completion(true,nil)
                }
                
            }
            catch {
                
                print(error)
                completion(false,error)
                
            }
            
        }
        task.resume()
        
        
        
    }
    
    class func getUserData(completion: @escaping (Bool,Error?) -> Void){
        
        let request = "https://onthemap-api.udacity.com/v1/users/\(Auth.key)"
        // OTMClient.Endpoints.getUserData.url
        let task = URLSession.shared.dataTask(with:URL(string: request)! ) { (data, response, error) in
            
            guard let data = data else {
                
                completion(false,error)
                return
                
            }
            
            let decoder = JSONDecoder()
            
            do {
                
                let responseObj = try decoder.decode(UserResponseModel.self, from: data)
                Auth.firstName = responseObj.user.firstName
                Auth.lastName = responseObj.user.lastName
                
                DispatchQueue.main.async {
                    completion(true,nil)
                }
                
            } catch {
                completion(false,error)
                
            }
            
            
        }
        
        task.resume()
        
    }
    
    class func userLogin(email: String, password: String, completion: @escaping (Bool, Error?)->Void) {
        
        var request = URLRequest(url: OTMClient.Endpoints.userLogin.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // let body = AuthRequest(email: email, password: password)
        let body = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        // encoding a JSON body from a string, can also use a Codable struct
        
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                completion(false,error)
                return
            }
            
            print(String(data: data, encoding: .utf8)!)
            let decoder = JSONDecoder()
            let newData = data.subdata(in: 5..<data.count)
            print(String(data: newData, encoding: .utf8)!)
            
            
            do {
                
                let  responseObject = try decoder.decode(LoginResponseModel.self, from: newData)
                Auth.sessionId = responseObject.session.id
                Auth.key = responseObject.account.key
                
                getUserData { success, error in
                    
                    if success {
                        print("Fetch user data completed!")
                    }
                    
                }
                
                DispatchQueue.main.async {
                    completion(true,nil)
                }
                
                
            } catch {
                
                print("Here is the error")
                print(error)
                completion(false,error)
                
            }
            
            
        }
        
        task.resume()
        
        
    }
    
    class func userLogout(completion: @escaping (Bool, Error?) -> Void){
        
        var request = URLRequest(url: OTMClient.Endpoints.userLogout.url)
        
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            
            guard let data = data else {
                return
            }
            
            if error == nil {
                
                let newData = data.subdata(in: 5..<data.count)
                print(String(data: newData, encoding: .utf8)!)
                
                DispatchQueue.main.async {
                    completion(true,nil)
                }
                
                
            } else {
                print(error?.localizedDescription as Any)
            }

        }
        
        task.resume()
        
    }
    
    class func getStudents(completion: @escaping ([StudentResponseModel],Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: OTMClient.Endpoints.getStudentsLocation(100).url) { (data,response,error) in
            
            guard let data = data else {
                completion([],error)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                
                let response = try decoder.decode(StudentInformationResponseModel.self, from: data)
                DispatchQueue.main.async {
                    completion(response.results,nil)
                }
                
            } catch {
                completion([],error)
                print(error.localizedDescription)
            }
            
            
        }
        
        task.resume()
    }
    
    
}
