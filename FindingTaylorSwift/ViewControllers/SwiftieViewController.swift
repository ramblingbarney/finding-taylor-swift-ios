//
//  SwiftieViewController.swift
//  FindingTaylorSwift
//
//  Created by The App Experts on 06/02/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit

class SwiftieViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.738589704, blue: 0.9438112974, alpha: 1)
        self.navigationItem.title = "SWIFTIES"
        
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
