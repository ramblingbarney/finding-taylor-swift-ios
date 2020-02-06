//
//  FindViewController.swift
//  FindingTaylorSwift
//
//  Created by The App Experts on 04/02/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit
import CropViewController

protocol ProgressErrorDelegate: class {
    func showErrorAlert(errorMessage: String)
    func startProgressBar()
    func completeProgressBar()
}

class FindViewController: UIViewController, CropViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var selectImage: UIBarButtonItem!
    @IBOutlet var uploadSelectedImage: UIBarButtonItem!
    @IBOutlet var imageView: UIImageView!
    private var image: UIImage?
    
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    private var awsFilehandle = AWSFileHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.738589704, blue: 0.9438112974, alpha: 1)
        self.navigationItem.title = "FINDING TAYLOR SWIFT"
        
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        self.navigationItem.leftBarButtonItem?.tintColor = .white
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        imageView.isUserInteractionEnabled = true
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        
        if #available(iOS 11.0, *) {
            imageView.accessibilityIgnoresInvertColors = true
        }
        view.addSubview(imageView)
        
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(didTapImageView))
        imageView.addGestureRecognizer(tapRecognizer)
        awsFilehandle.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self
        
        self.image = image
        
        //If profile picture, push onto the same navigation stack
        if croppingStyle == .circular {
            if picker.sourceType == .camera {
                picker.dismiss(animated: true, completion: {
                    self.present(cropController, animated: true, completion: nil)
                })
            } else {
                picker.pushViewController(cropController, animated: true)
            }
        }
        else { //otherwise dismiss, and then present from the main controller
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
            })
        }
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    private func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        imageView.image = image
        layoutImageView()
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        if cropViewController.croppingStyle != .circular {
            imageView.isHidden = true
            
            cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
                                                   toView: imageView,
                                                   toFrame: CGRect.zero,
                                                   setup: { self.layoutImageView() },
                                                   completion: {
                                                    self.imageView.isHidden = false })
        }
        else {
            self.imageView.isHidden = false
            cropViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc public func didTapImageView() {
        // When tapping the image view, restore the image to the previous cropping state
        let cropViewController = CropViewController(croppingStyle: self.croppingStyle, image: self.image!)
        cropViewController.delegate = self
        let viewFrame = view.convert(imageView.frame, to: navigationController!.view)
        
        cropViewController.presentAnimatedFrom(self,
                                               fromImage: self.imageView.image,
                                               fromView: nil,
                                               fromFrame: viewFrame,
                                               angle: self.croppedAngle,
                                               toImageFrame: self.croppedRect,
                                               setup: { self.imageView.isHidden = true },
                                               completion: nil)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutImageView()
    }
    
    private func layoutImageView() {
        guard imageView.image != nil else { return }
        
        let margins = view.layoutMarginsGuide
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 5.0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -5.0).isActive = true
        imageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 5.0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -5.0).isActive = true
        view.addSubview(imageView)
    }
    
    @IBAction func clickSelectImage(_ sender: UIBarButtonItem) {
        
        self.croppingStyle = .default
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func clickUploadSelectedImage(_ sender: UIBarButtonItem) {
        
        guard let image = imageView.image else {
            return
        }
        
        navigationItem.title = "Uploading Image..."
        awsFilehandle.uploadFile(withImage: image, bucketName: "match-image")
    }
}

extension FindViewController: ProgressErrorDelegate {
    
    internal func showErrorAlert(errorMessage: String){
        
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            print("Pressed OK")
        }
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
    
    internal func startProgressBar() {
        
        let notification = ProgressNotification(.executing)
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: ProgressNotificationDetails.kProgressUpdateNotification), object: notification)
        }
    }
    
    internal func completeProgressBar() {
        
        let notification = ProgressNotification(.done)
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: ProgressNotificationDetails.kProgressUpdateNotification), object: notification)
        }
        self.navigationItem.title = "FINDING TAYLOR SWIFT"
    }
}

