import SystemConfiguration
import Alamofire

//MARK: -  Checking the network connection

struct Connectivity {
  static let sharedInstance = NetworkReachabilityManager()!
  static var isConnectedToNetwork:Bool {
      return self.sharedInstance.isReachable
    }
}


