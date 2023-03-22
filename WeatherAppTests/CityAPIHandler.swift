import Foundation

struct CityAPIData {
    let cod, message: String?
    let response: CityAPIResponse?
}

struct CityValidation {
    func validate(request: CityRequest) -> ValidationResponse {
        if let _ = request.lat, let _ = request.lon {
            return ValidationResponse(message: nil, cod: nil, isValid: true)
        }
        return ValidationResponse(message: "Lattitude & Longitude should not be empty", cod: "400", isValid: false)
    }
}
   
    
struct CityAPIHandler {

    private let validation = CityValidation()
    private let cityApiResource = CityApiResource()

    func authenticateUser(request: CityRequest, completionHandler: @escaping(_ loginData: CityAPIData?)->()) {
        let validationResult = validation.validate(request: request)
        if(validationResult.isValid) {
            cityApiResource.authenticateUser(request: request) { (response) in
                // return it back to the caller
                completionHandler(CityAPIData(cod: nil, message: nil, response: response))
            }
        }else{
            completionHandler(CityAPIData(cod: validationResult.cod, message: validationResult.message, response: nil))
        }
    }
}
