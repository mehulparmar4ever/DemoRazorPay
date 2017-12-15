//
//  ViewController.swift
//  DemoRazorPay
//
//  Created by Company on 12/14/17.
//  Copyright © 2017 Company. All rights reserved.
//

import UIKit
import Razorpay

let KEY_ID = "***************";
let SUCCESS_TITLE = "Yay!";
let SUCCESS_MESSAGE = "Your payment was successful.";
let FAILURE_TITLE = "Uh-Oh!";
let FAILURE_MESSAGE = "Your payment failed due to an error.";
let EXTERNAL_METHOD_TITLE = "Umm?";
let EXTERNAL_METHOD_MESSAGE = "You selected %@, which is not supported by Razorpay at the moment.\nDo you want to handle it separately?";
let OK_BUTTON_TITLE = "OK";

extension ViewController : ExternalWalletSelectionProtocol {
    func onExternalWalletSelected(_ walletName: String, WithPaymentData paymentData: [AnyHashable : Any]?) {
        self.showAlert(EXTERNAL_METHOD_TITLE, message: "\(EXTERNAL_METHOD_MESSAGE) walletName :\(walletName), paymentData:\(String(describing: paymentData))")
    }
}

extension ViewController : RazorpayPaymentCompletionProtocol {
    func onPaymentError(_ code: Int32, description str: String) {
        self.showAlert(FAILURE_TITLE, message: "\(FAILURE_MESSAGE) code :\(code), description str:\(str)")
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        self.showAlert(SUCCESS_TITLE, message: "\(SUCCESS_MESSAGE) payment_id :\(payment_id)")
    }
}

class ViewController: UIViewController {
    var razorpay : Razorpay?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        razorpay = Razorpay.initWithKey(KEY_ID, andDelegate: self)
        razorpay?.setExternalWalletSelectionDelegate(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnPayClicked(_ sender: Any) {
        let options : Dictionary<String, Any> = ["amount":"100", "currency":"INR", "description":"Fine T-shirt", "image":#imageLiteral(resourceName: "logo"), "name":"Razorpay", "external":["wallets":["paytm"]], "prefill":["email":"contact@razorpay.com", "contact":"18002700323"], "theme":["color":"#3594E2"]]
        razorpay?.open(options)
    }
    
    func showAlert(_ title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        UIApplication.shared.beginIgnoringInteractionEvents()

        self.present(alertController, animated: true, completion: {
            if UIApplication.shared.isIgnoringInteractionEvents {
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        })
    }
}

