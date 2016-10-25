//
//  ImageViewController.swift
//  Notes
//
//  Created by Ben Larrabee on 10/19/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let image = NoteStore.shared.selectedImage {
      imageView.image = image
    }
  
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
  @IBAction func close(_ sender: AnyObject) {
    NoteStore.shared.selectedImage = nil
    dismiss(animated: true, completion: nil)
  }



}
