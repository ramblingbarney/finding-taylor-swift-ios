//
//  InformationViewController.swift
//  FindingTaylorSwift
//
//  Created by The App Experts on 05/02/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {

    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the Show Help Screen Switch
        self.defaults.set(true, forKey: SeenHelpInformation.seenHelp)
    }
}
