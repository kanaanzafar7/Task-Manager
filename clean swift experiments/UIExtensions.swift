
import UIKit
extension UIViewController {
    func showDialog(title : String, message : String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in}))
        self.present(ac, animated: true)
    }
    func showWarningDialog (title : String, message : String, okayHandler : ((UIAlertAction) -> Void)?){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "No", style: .cancel, handler: { alertAction in
        }))
        let okAction = UIAlertAction(title: "Yes", style: .default, handler: okayHandler)
        ac.addAction(okAction)
        self.present(ac, animated: true)
    }
    func showLoadingState () {
   /*     let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        self.present(alert, animated: true, completion: nil)
 */   }
    func hideLoadingState(){
//        self.dismiss(animated: true, completion: nil)
        
    }
}

extension UIButton {
    func showLoading(activityIndicatorView: UIActivityIndicatorView){
        self.setTitle("", for: .normal)
        self.alpha = 0.4
        self.isEnabled = false
        activityIndicatorView.frame = self.bounds
        self.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
    }
    func hideLoading(activityIndicatorView: UIActivityIndicatorView, label : String){
        self.isEnabled = true
        self.alpha = 1.0
        self.setTitle(label, for: .normal)
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
}
