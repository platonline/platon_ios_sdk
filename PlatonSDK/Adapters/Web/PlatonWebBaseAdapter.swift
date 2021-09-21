import Foundation

/// Callback type for all Web Pament requests
public typealias PlatonWebCalback<T> = ((_ result: T, _ response: URLResponse?) -> Void)?

/// Base Web Payment API adaper
public class PlatonWebBaseAdapter: PlatonBaseAdapter {
    
    /// Method for sending request and parsing data on PlatonError
    ///
    /// - Parameters:
    ///   - parameters: all paramters and data
    ///   - completion: callback which will hold Request Data which has url for web request
    func procesedWebRequest(parameters: [PlatonParametersProtocol?],
                            completion: PlatonWebCalback<PlatonResponse<String>> = nil) {
        
        guard let credentials = PlatonSDK.shared.credentials,
              let url = URLComponents(string: credentials.paymentUrl) else {
            completion?(PlatonResponse.failure(PlatonError(type: .sdkAuth)), nil)
            return
        }
        
        let params = genereatePaymentParamters(parameters,
                                               credentials: credentials)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        var request = URLRequest(url: url.url!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8"]
        request.httpBody = params.prepareQuery().data(using: .utf8)
        let tast = session.dataTask(with: request) { (data, response, error) in
            let result = self.parseStringResponse(data: data, response: response, error: error)
            DispatchQueue.main.async {
                completion?(result, response)
            }
        }
        tast.resume()
    }
    
    override func genereatePaymentParamters(_ parameters: [PlatonParametersProtocol?],
                                   method: PlatonMethodAction? = nil,
                                   credentials: PlatonCredentials) -> AnyParams {
        
        let platonParams: [PlatonParametersProtocol?]
        
        if let unwMethod = method {
            platonParams = [unwMethod.platonParams,
                            parameters,
                            [PlatonMethodProperty.key: credentials.clientKey]]
        } else {
            platonParams = [parameters,
                            [PlatonMethodProperty.key: credentials.clientKey]]
        }
        
        return platonParams.anyParams
    }
    // MARK: - Addtitional fuctions
    
    func parseStringResponse(data: Data?, response: URLResponse?, error: Error?) -> PlatonResponse<String> {
        let parsedResponse: PlatonResponse<String>
        
        if let unwError = error {
            let errorCode = (unwError as NSError).code
            let error = PlatonError(message: unwError.localizedDescription, code: errorCode)
            parsedResponse = PlatonResponse.failure(error)
        } else if let unwData = data {
            if let platonError = try? JSONDecoder().decode(PlatonError.self, from: unwData) {
                parsedResponse = PlatonResponse.failure(platonError)
            } else if let decodedResponse = String(data: unwData, encoding: .utf8) {
                parsedResponse = PlatonResponse.success(decodedResponse)
            } else {
                parsedResponse = PlatonResponse.failure(PlatonError(type: .parse))
            }
        } else {
            parsedResponse = PlatonResponse.failure(PlatonError(type: .parse))
        }
        
        return parsedResponse
    }
    
}
