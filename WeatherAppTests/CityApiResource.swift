import Foundation

struct CityApiResource {
    
    func authenticateUser(request: CityRequest, completionHandler: @escaping(_ result: CityAPIResponse?)->()) {

        let urlRequest = generateLoginUrlRequest(request: request)

        URLSession.shared.dataTask(with: urlRequest) { (responseData, serverResponse, serverError) in
            if(serverError == nil && responseData != nil){
                do {
                    let result = try JSONDecoder().decode(CityAPIResponse.self, from: responseData!)
                    print(result)
                    completionHandler(result)
                } catch  {
                    debugPrint("Encoding request body failed")
                }
            }
        }.resume()
    }

    private func generateLoginUrlRequest(request: CityRequest) -> URLRequest{
        let url = String(format: Bundle.main.baseURL + Constants.kHomeURL, request.lat ?? "",request.lon ?? "",Constants.kAppid)
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        return urlRequest
    }
}
