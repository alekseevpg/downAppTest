import Foundation

enum BackendError: LocalizedError, Identifiable {
    case sadServer
    case noData
    case invalidHTTPStatusCode(code: Int, url: URL, message: String)
    case urlError(URLError)
    case badNetwork
    case inlineError(Error)

    var id: String {
        String(reflecting: self)
    }

    var errorTitle: String {
        switch self {
        case .sadServer:
            return "Sorry, server is sad at the moment :("
        case .noData:
            return "Sorry, server did not return any data :("
        case .badNetwork:
            return "Bad Network Connection"
        case .inlineError(let error):
            return error.localizedDescription
        default:
            return String(localized: "backendError.unknownError")
        }
    }

    var errorMessage: String {
        switch self {
        case .noData:
            return "Server coudn't send you back anything meaningful. Please contact developers with the steps to reproduce this issue."
        case .badNetwork:
            return "We're having trouble connecting to servers, please make sure your network connection is working and then try again."
        case .sadServer:
            return "Please, retry later"
        case .invalidHTTPStatusCode(_, _, let message):
            return message
        default:
            return localizedDescription
        }
    }
}
