//
//  TermsViewController.swift
//  DelyBazar
//
//  Created by OSX on 24/11/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {

    @IBOutlet weak var txtTerms: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTerms.text = "\nODIRMPL may at any time modify the Terms & Conditions of Use of the Website without any prior notification to you. You can access the latest version of these Terms & Conditions at any given time on the Site. You should regularly review the Terms & Conditions on the Site. In the event the modified Terms & Conditions is not acceptable to you, you should discontinue using the Service. However, if you continue to use the Service you shall be deemed to have agreed to accept and abide by the modified Terms & Conditions of Use of this Site.\n\nOnline Delybazar Internet Retail Market Pvt. Ltd. (“ODIRMPL”) is the licensed owner of the the website delybazar.com, as a visitor to the Site/Customer you are advised to please read the Terms & Conditions carefully.\n\n1. Delybazar.com delivers the products on its specified time slots according to the customer’s convenience.\n\n2. Final time of placing an order to get delivered on next day is 9 pm.\n\n3.  Order will be delivered on next day.\n\n4. Current modes of payments are cash on delivery, PayU Money Checkout, Paytm Wallet.\n\n5. We do not accept Cheque or Demand Draft.\n\n6. Copy of your invoices will be provided at the time of your delivery.\n\n7. Delivery time can be delayed due to unavoidable circumstances like traffic congestions, road blocks or any natural calamities.\n\n8. Customer is liable to collect his ordered product from his doorstep.\n\n9. If a customer places an order & the product becomes suddenly unavailable from the market then delybazar.com reserves the right to cancel the order.\n\n10. The product images may differ from the original one. ( We make efforts to display available products, including in respect of their color, size, shape and appearance, as accurately as possible. However, the actual color, size, shape and appearance may have variations from the depiction on your mobile/computer screen.)\n\n11. In case of fishes, all weights are measured before descaling & cleaning, weight could be 15%-35% less than the actual weight for few fishes, Due to descaling & cleaning.\n\n12. We aim to ensure that prices of all products are correct and up-to-date. However, from time to time, prices for certain products may not be current or may be inaccurate on account of technical issues, typographical errors or incorrect product information provided to the Company by a supplier.\n\n13. You will provide authentic and true information in all instances where any information is requested from you. The Company reserves the right to confirm and validate the information and other details provided by you at any point of time. If at any time, the information provided by you is found to be false or inaccurate (wholly or partly), the Company shall have the right in its sole discretion to reject registration, cancel all orders.\n\n14.  You shall not attempt to gain unauthorized access to any portion or feature of the Delybazar.com, or any other systems or networks connected to the  or to any server, computer, network, or to any of the services offered on or through Delybazar.com, by hacking, password 'mining' or any other illegitimate means.\n\n15. Delybazar.com holds the rights to deactivate any coupon codes, vouchers at ant point of time.\n\n16. Services of the Site would be available to only select geographies in India. Persons who are 'incompetent to contract' within the meaning of the Indian Contract Act, 1872 including un-discharged insolvents etc. are not eligible to use the Site. If you are a minor i.e. under the age of 18 years but at least 13 years of age you may use the Site only under the supervision of a parent or legal guardian who agrees to be bound by these Terms of Use.\n\n17. All shoppers have to register and login for placing orders on the Site. You have to keep your account and registration details current and correct for communications related to your purchases from the site. By agreeing to the terms and conditions, the shopper agrees to receive promotional communication and newsletters upon registration.\n\n18. Delybazar.com may at any time modify the Terms & Conditions of Use of the Website without any prior notification to you. You can access the latest version of these Terms & Conditions at any given time on the Site. You should regularly review the Terms & Conditions on the Site. In the event the modified Terms & Conditions is not acceptable to you, you should discontinue using the Service. However, if you continue to use the Service you shall be deemed to have agreed to accept and abide by the modified Terms & Conditions of Use of this Site."
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        
          self.dismiss(animated: true, completion: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
