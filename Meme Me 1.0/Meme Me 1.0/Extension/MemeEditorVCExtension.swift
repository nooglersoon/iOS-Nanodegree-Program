//
//  ViewControllerExtension.swift
//  Meme Me 1.0
//
//  Created by Fauzi Achmad B D on 15/08/21.
//

import Foundation
import UIKit

extension MemeEditorVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    // Fixed the keyboard issue
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if bottomTextField.isFirstResponder {
            
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    // Method to get the height of keyboard
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // Method to subscribe keyboard notification
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Method to unsubscribe keyboard notification
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Method when the keyboard are going to hide
    
    @objc func keyboardWillHide(_ notification: Notification){
        
        view.frame.origin.y = 0
        
    }
    
    
    
}

extension MemeEditorVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Method to select the image either from album or camera and set the selected image to image view
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            pickerImageView.contentMode = .scaleAspectFit
            pickerImageView.image = image
            sharedButton.isEnabled = true
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    // Method to dismiss the view if the user canceled the picker controller
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
}
