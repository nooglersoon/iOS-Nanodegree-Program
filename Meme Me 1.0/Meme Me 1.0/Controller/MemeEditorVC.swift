//
//  ViewController.swift
//  Meme Me 1.0
//
//  Created by Fauzi Achmad B D on 15/08/21.
//

import UIKit

class MemeEditorVC: UIViewController {
    
    // Declare IBOutlet and Create Connection
    
    @IBOutlet weak var pickerImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraImagePicker: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var sharedButton: UIBarButtonItem!
    
    // Initialize the default image. The image which the user see at first time or when the user have restart to create new meme!
    var defaultImage = UIImage(systemName: "photo")?
        .withTintColor(.systemGray5, renderingMode: .alwaysOriginal)
    
    
    // Set the meme text attributes customization
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -5
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Set the initial condition when the app is fully loaded. Set the image to default and shared button is disabled
        pickerImageView.image = defaultImage
        sharedButton.isEnabled = false
        
        // Set up the initial condition text field
        setUpTextField(topTextField)
        setUpTextField(bottomTextField)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        // Check if the device has camera. Disabled the option if it hasn't
        
        cameraImagePicker.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Subsrcibe Keyboard Notifications
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(true)
        
        // Unsubsrcibe Keyboard Notifications
        unsubscribeFromKeyboardNotifications()
    }
    
    // Method to setup initial condition of textfield
    func setUpTextField(_ textField: UITextField){
        
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        
    }
    
    // Method to cancel all action and set the image and textfield as default condition
    @IBAction func cancelAllAction(_ sender: Any) {
        
        pickerImageView.image = defaultImage
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
    // Method to close the meme editor
    @IBAction func cancelMemeEditorTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    // Method when image pickedUp and check the Image picker Controller sourcetype
    func imagePickedTapped(_ source: UIImagePickerController.SourceType) {
        
        let controller = UIImagePickerController()
        controller.allowsEditing = true
        controller.sourceType = source
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func albumImagePickerTapped(_ sender: Any) {
        
        imagePickedTapped(.photoLibrary)
        
        
    }
    
    @IBAction func cameraImagePickerTapped(_ sender: Any) {
        
        imagePickedTapped(.camera)
        
        
    }
    
    // Method when shared button is tapped
    @IBAction func sharedTapped(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        let shareController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        // Set the toolbar and navbar to hidden for capturing images from view
        toolBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
        
        shareController.completionWithItemsHandler = {_, completed, _, _ in
            if completed {
                
                self.save(memedImage)
                // create alert after completed save the meme
                let alert = UIAlertController(title: "Congratulations! 🥳", message: "Your Meme is Saved on Your Album", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "Create New Meme! 😁", style: UIAlertAction.Style.default, handler: {_ in
                    
                    self.cancelAllAction(self)
                    self.dismiss(animated: true, completion: nil)
                    
                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
        
        
        present(shareController, animated: true,completion: nil)
        
        
    }
    
    // Save method to initialize Meme Object
    
    func save(_ memedImage: UIImage){
        
        // Shared Meme List
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        
        // Instance of Meme Object
        let meme = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: self.pickerImageView.image!, memedImage: memedImage)
        
        // Append to memes
        appDelegate.memes.append(meme)
        print("Saved")
    }
    
    // Method for generating new image from view
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        navigationController?.navigationBar.isHidden = true
        toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        
        return memedImage
    }
    
}



