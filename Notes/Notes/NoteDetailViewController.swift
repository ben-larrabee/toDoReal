//
//  NoteDetailViewController.swift
//  Notes
//
//  Created by Ben Larrabee on 10/18/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController {
  @IBOutlet weak var noteTextView: UITextView!
  @IBOutlet weak var noteTitleField: UITextField!
  @IBOutlet weak var imageView: UIImageView!

  var gestureRecognizer: UITapGestureRecognizer!
  
  var note = Note()
  
    override func viewDidLoad() {
      super.viewDidLoad()
      
      noteTitleField.text = note.title
      noteTextView.text = note.text
      
      if let image = note.image {
        imageView.image = image
        addGestureRecognizer()
      } else {
        imageView.isHidden = true
      }
  
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  func addGestureRecognizer() {
    gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewImage))
    imageView.addGestureRecognizer(gestureRecognizer)
  }
  
  func viewImage() {
    if let image = imageView.image {
      NoteStore.shared.selectedImage = image
      let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageNavController")
      present(viewController, animated: true, completion: nil)
    }
  }
  
  fileprivate func showPicker(_ type: UIImagePickerControllerSourceType) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = type
    present(imagePicker, animated: true, completion: nil)
  }
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    note.title = noteTitleField.text!
    note.text = noteTextView.text
    note.date = Date()
    note.image = imageView.image
  }

  
  // MARK: - IBActions
  @IBAction func choosePhoto(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Picture", message: "Choose a Picture", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action) in
      self.showPicker(.camera)
    }))
    alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action) in
      self.showPicker(.photoLibrary)
    }))
    present(alert, animated: true, completion: nil)
  }
  
}

extension NoteDetailViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    picker.dismiss(animated: true, completion: nil)
    
    if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
      let maxSize: CGFloat = 512
//      let scale = maxSize / image.size.width
//      let newHeight = image.size.height * scale
//      UIGraphicsBeginImageContext(CGSize(width: maxSize, height: newHeight))
//      image.draw(in: CGRect(x: 0, y: 0, width: maxSize, height: newHeight))
//      let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
//      UIGraphicsEndImageContext()
//      if image.size.width < image.size.height {
            let scale = maxSize / image.size.width
            let newHeight = image.size.height * scale
            UIGraphicsBeginImageContext(CGSize(width: maxSize, height: newHeight))
            image.draw(in: CGRect(x: 0, y: 0, width: maxSize, height: newHeight))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
      //      UIGraphicsEndImageContext()
//      } else {
//        let scale = maxSize / image.size.height
//        let newWidth = image.size.width * scale
//        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: maxSize))
//        
//      }
      
      
      imageView.image = resizedImage
      
      imageView.isHidden = false
      if gestureRecognizer != nil {
        imageView.removeGestureRecognizer(gestureRecognizer)
        
      }
      addGestureRecognizer()
    }
  }
}




