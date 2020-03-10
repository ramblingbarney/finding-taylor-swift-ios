//
//  UINavigationBar.swift
//  FindingTaylorSwift
//
//  Created by The App Experts on 05/02/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//
import UIKit

extension UINavigationController {

    open override func viewDidLoad() {
        super.viewDidLoad()

        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.tag = ProgressNotificationDetails.kProgressViewTag
        self.view.addSubview(progressView)
        let navBar = self.navigationBar
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[navBar]-0-[progressView]", options: .directionLeadingToTrailing, metrics: nil, views: ["progressView": progressView, "navBar": navBar]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[progressView]|", options: .directionLeadingToTrailing, metrics: nil, views: ["progressView": progressView]))

        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.setProgress(0.0, animated: false)

        NotificationCenter.default.addObserver(self, selector: #selector(UINavigationController.didReceiveNotification(notification:)), name: NSNotification.Name(rawValue: ProgressNotificationDetails.kProgressUpdateNotification), object: nil)
    }

    var progressView: UIProgressView? {
        return self.view.viewWithTag(ProgressNotificationDetails.kProgressViewTag) as? UIProgressView
    }

    @objc func didReceiveNotification(notification: NSNotification) {
        if let progress = notification.object as? ProgressNotification {
            if progress.current == progress.total {
                self.progressView?.setProgress(1.0, animated: true)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    self.progressView?.setProgress(0.0, animated: false)
                }

            } else {
                let perc = Float(progress.current) / Float(progress.total)
                self.progressView?.setProgress(perc, animated: true)
            }
        }
    }
}

class ProgressNotification {

    enum Status: Int {
        case none = 0
        case executing = 10
        case done = 20
    }

    var current: Int
    var total: Int

    init(_ status: Status) {
        total = Status.done.rawValue
        current = status.rawValue
    }
}
