import UIKit

enum Register
{
    // MARK: Use cases
    
    enum SignUp
    {
        struct Request
        {
            let username,email,  password: String
        }
        struct Response
        {
        }
        struct ViewModel
        {
        }
        struct ViewModelSuccess{
            let name: String
        }
        struct ViewModelError{
            let error: Error
        }
    }
}
