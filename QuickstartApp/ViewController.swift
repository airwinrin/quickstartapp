import GoogleAPIClientForREST
import GoogleSignIn
import UIKit

class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    
// If modifying these scopes, delete your previously saved credentials by
// resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLRAuthScopeSheetsSpreadsheetsReadonly]
    
    private let service = GTLRSheetsService()
    let signInButton = GIDSignInButton()
//    let output = UITextView()

    @IBOutlet weak var outputTextView: UITextView!
    

////   *viewDidLoad....*viewDidLoad....* *viewDidLoad....*viewDidLoad....**viewDidLoad....*viewDidLoad....**viewDidLoad....*viewDidLoad....*
    
override func viewDidLoad() {
    super.viewDidLoad()
        
        // Configure Google Sign-in.
                GIDSignIn.sharedInstance().delegate = self
                GIDSignIn.sharedInstance().uiDelegate = self
                GIDSignIn.sharedInstance().scopes = scopes
                GIDSignIn.sharedInstance().signInSilently()
    
        // Add the sign-in button.
                view.addSubview(signInButton)
    
    }
    
// *..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*.. //
    
    
////  *allFunctions.....*allFunctions....*allFunctions....*allFunctions....*allFunctions....*allFunctions....*allFunctions....*allFunctions....*allFunctions....
    
//SIGN-IN
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.outputTextView.isHidden = false
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            
          listAll()
            
        }
    }

                                        //Helper Alert
                                            func showAlert(title : String, message: String) {
                                                let alert = UIAlertController(
                                                    title: title,
                                                    message: message,
                                                    preferredStyle: UIAlertControllerStyle.alert
                                                )
                                                let ok = UIAlertAction(
                                                    title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil
                                                )
                                                alert.addAction(ok)
                                                present(alert, animated: true, completion: nil)
                                            }


//Process the response and Display output
        @objc func displayResultWithTicket(ticket: GTLRServiceTicket,
                                           finishedWithObject result : GTLRSheets_ValueRange,
                                           error : NSError?) {
    
            if let error = error {
                showAlert(title: "Error", message: error.localizedDescription)
                return
            }
    
            outputTextView.text = result.values!.description
            
        }
    
//Get Data from Google Sheets
    func listAll() {
        let spreadsheetId = "1z8IlNL4SC-XeYiZRG_uSbEnbBycoHMfzensFlIsQaqs"
        let range = "A1:U300"
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: spreadsheetId, range:range)
        service.executeQuery(query, delegate: self, didFinish: #selector(ViewController.displayResultWithTicket(ticket:finishedWithObject:error:))
        )
    }
    
//newVC
    func navigateToNewVC() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyBoard.instantiateViewController(withIdentifier: "newVC")
        self.present(newVC, animated: true, completion: nil)
    }
    
//Button navigate to NewVC
    @IBAction func navigateToNewVCButton(_ sender: UIButton) {
        navigateToNewVC()
    }

//search field
    @IBAction func searchField(_ sender: UITextField) {
    }
    
    
// *..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*..*.. //
    
} // <-- Class Close
