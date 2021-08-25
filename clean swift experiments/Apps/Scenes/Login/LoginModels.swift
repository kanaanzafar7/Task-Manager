import UIKit

enum Login
{
    // MARK: Use cases
    
    enum Something
    {
        struct Request
        {
        }
        struct Response
        {
        }
        struct ViewModel
        {
        }
    }
    
    enum Login {
        struct Request
        {
            let email : String
            let password : String
        }
        struct Response
        {
            let name : String?
            let error : Error?
        }
        struct LoginSuccess
        {
            let name : String
        }
        
        struct LoginFailure{
            let loginError : Error
        }
    }
    
    
}
