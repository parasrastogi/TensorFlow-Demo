//
//  TabViewViewModel.swift
//  TenserFlow Demo
//
//  Created by Paras Rastogi on 23/12/20.
//

import Foundation
import Bond
import Alamofire

enum Tabs : Int  {
    case classification = 0
    case objectDetection = 1
    case imageQuality = 2
    
    var title : String{
        switch self {
        case .classification:
            return "Classification"
        case .objectDetection:
            return "ObjectDetection"
        case .imageQuality:
            return "ImageQuality"
        }
    }
}
class TabViewViewModel{

    let tabButtons = MutableObservableArray<Tabs>([Tabs.classification,Tabs.objectDetection,Tabs.imageQuality])
    let selectedTab = Observable<Tabs>(.classification)
    var tabSelectedIndexPath = IndexPath(item: 0, section: 0)
 
    func getBase64(image: UIImage) -> String{
        let imageData:NSData = image.pngData()! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        return strBase64
    }
    
    func uploadImage(image: UIImage, completion: @escaping (AllResponse) -> Void ){
        if let compressedImageData = image.jpeg(.medium) {
            UtilityManager.showProgress(status: "Uploading photo...")
            let compressedJPGImage = UIImage(data: compressedImageData)
            let imageData = ["content": getBase64(image: compressedJPGImage!)]
            let request : [String: Any] = ["request_type": "AL", "input_type":"BASE64", "API_KEY":"GDWJC8P38YQL3S2","image": imageData ]
            let requestParam = ["request" : request]
            
            Alamofire.request("https://api.inscene.ai/annotate?v=1.3", method: .post, parameters: requestParam, encoding: JSONEncoding.default)
                .responseJSON { response in
                    UtilityManager.hideProgress()
                    switch response.result{
                    case .success(let res):
                        if let res = res as? [String : Any]{
                            do {
                                print(res)
                                let  responseData = try DataCoder.decode(AllResponse.self, from: res)
                                completion(responseData)
                                debugPrint(responseData)
                            } catch {
                                print(error)
                            }
                        }
                    case .failure(_):
                        debugPrint("jError response")
                        
                    }
                }
        }else{
            debugPrint("Image compression failed.")
        }
    }
   
}
