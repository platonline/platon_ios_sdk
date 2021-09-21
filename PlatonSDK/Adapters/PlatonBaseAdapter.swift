import Foundation

/// Callback type for all Post Pament requests
public typealias PlatonCalback<T> = ((_ result: T) -> Void)?

/// Base Post Payment API adaper
public class PlatonBaseAdapter {
    
    /// Method for sending request and parsing data on PlatonError
    ///
    /// - Parameters:
    ///   - restApiMethod: api method (action)
    ///   - parameters: all paramters and data
    ///   - completion: callback that will return response
    func procesedRequest(restApiMethod: PlatonMethodAction? = nil,
                         parameters: [PlatonParametersProtocol?],
                         completion: PlatonCalback<PlatonResponse<Data>> = nil) {
        
        guard let credentials = PlatonSDK.shared.credentials else {
            completion?(PlatonResponse.failure(PlatonError(type: .sdkAuth)))
            return
        }
        var baseUrl: String? = credentials.paymentUrl
        switch restApiMethod {
            case .transactionState:
                baseUrl = credentials.stateUrl
            default:
                break
        }
        guard let baseUrl = baseUrl,
              let url = URLComponents(string: baseUrl) else {
            completion?(PlatonResponse.failure(PlatonError(type: .sdkAuth)))
            return
        }

        let params = genereatePaymentParamters(parameters,
                                               method: restApiMethod,
                                               credentials: credentials)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        var request = URLRequest(url: url.url!)
        request.httpMethod = "POST"
        request.httpBody = params.prepareQuery().data(using: .utf8)
        let tast = session.dataTask(with: request) { (data, response, error) in
            let result = self.parseResponse(data: data, response: response, error: error)
            DispatchQueue.main.async {
                completion?(result)
            }
        }
        tast.resume()

    }
    // MARK: - Additional functions
    
    func parseResponse(data: Data?, response: URLResponse?, error: Error?) -> PlatonResponse<Data> {
        let parsedResponse: PlatonResponse<Data>
        
        if let unwError = error {
            let errorCode = (unwError as NSError).code
            let error = PlatonError(message: unwError.localizedDescription, code: errorCode)
            
            parsedResponse = PlatonResponse.failure(error)
            
        } else if let unwData = data {
            
            if let platonError = try? JSONDecoder().decode(PlatonError.self, from: unwData) {
                parsedResponse = PlatonResponse.failure(platonError)
            } else {
                parsedResponse = PlatonResponse.success(unwData)
            }
            
        } else {
            parsedResponse = PlatonResponse.failure(PlatonError(type: .parse))
        }
        
        return parsedResponse
    }

    func genereatePaymentParamters(_ parameters: [PlatonParametersProtocol?],
                                   method: PlatonMethodAction? = nil,
                                   credentials: PlatonCredentials) -> AnyParams {
        
        let platonParams: [PlatonParametersProtocol?]
        
        if let unwMethod = method {
            platonParams = [unwMethod.platonParams,
                            parameters,
                            [PlatonMethodProperty.clientKey: credentials.clientKey]]
        } else {
            platonParams = [parameters,
                            [PlatonMethodProperty.clientKey: credentials.clientKey]]
        }
        
        return platonParams.anyParams
    }
    
}
