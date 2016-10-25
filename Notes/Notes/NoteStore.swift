//
//  NoteStore.swift
//  Notes
//
//  Created by Ben Larrabee on 10/19/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//

import UIKit

class NoteStore {
  static let shared = NoteStore() // singleton
  fileprivate var notes: [Note]!
  var currentCategoryIndex = 1
  var selectedImage: UIImage?
  
  init() {
    let noteFilePath = archiveFilePath()
    let noteFileManager = FileManager.default
    if noteFileManager.fileExists(atPath: noteFilePath) {
      notes = NSKeyedUnarchiver.unarchiveObject(withFile: noteFilePath) as! [Note]
    } else {
      notes = []
      notes.append(Note(title: "By Ben Larrabee", text: "Ben Larrabee is a TA with TEKY.  This app was created as part of a 9 month coding bootcamp.  Look him up, he's a cool guy."))
      notes.append(Note(title: "Getting Started", text: "Add Notes by clicking the plus button.\nSee full details by clicking on any note.  You can also edit a note by clicking on it, then making changes in the detail view, and then saving changes.  You can swipe left to delete a note."))
      notes.append(Note(title: "Welcome", text: "This is ElevenNote, an app created for TEKY"))
      save()
    }
    
    
    
    
    
    
    sort()
  }


  // MARK: - Public functions
  func getNote(_ index: Int) -> Note {
    return notes[index]
  }
  func addNote(_ note: Note) {
    notes.insert(note, at: 0)
  }
  func updateNote(_ note: Note, index : Int) {
    notes[index] = note
  }
  func deleteNote(_ index: Int) {
    notes.remove(at: index)
  }
  func getCount() -> Int {
    return notes.count
  }
  func save() {
    NSKeyedArchiver.archiveRootObject(notes, toFile: archiveFilePath())
  }
  func sort() {
    // notes.sort { (note1, note2) -> Bool in
    //  return note1.date.compare(note2.date) == .orderedDescending
    //}
    notes.sort { $0.date.compare($1.date) == .orderedDescending
    }
  }
  
  // Mark: - PRivate Functions
  fileprivate func archiveFilePath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentDirectory = paths.first!
    let path = (documentDirectory as NSString).appendingPathComponent("NoteStore.plist")
    return path
  }
  
}
