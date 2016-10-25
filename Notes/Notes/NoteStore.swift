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
  fileprivate var categories: [ToDoCategory]!
  var currentCategoryIndex = 1
  var selectedImage: UIImage?
  var sortedNotes: [[Note]]!
  
  init() {
    let noteFilePath = archiveFilePath(task: "NoteStore.plist")
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
    let categoryFilePath = archiveFilePath(task: "CategoryStore.plist")
    let categoryFileManager = FileManager.default
    if categoryFileManager.fileExists(atPath: categoryFilePath) {
      categories = NSKeyedUnarchiver.unarchiveObject(withFile: categoryFilePath) as! [ToDoCategory]
    } else {
      categories = []
      categories.append(ToDoCategory(name: "Unorganized"))
    }
    sort()
  }


  // MARK: - Public functions
  func getNote(at category: Int, index: Int) -> Note {
    print("the index is \(index)")
    return sortedNotes[category][index]
  }
  func addNote(_ note: Note) {
    notes.insert(note, at: 0)
  }
  func updateNote(_ note: Note, category: Int, index : Int) {
    sortedNotes[category][index] = note
  }
  func deleteNote(_ category: Int, index: Int) {
    sortedNotes[category].remove(at: index)
  }
  func getCount() -> Int {
    return notes.count
  }
  func save() {
    NSKeyedArchiver.archiveRootObject(notes, toFile: archiveFilePath(task: "NoteStore.plist"))
    NSKeyedArchiver.archiveRootObject(categories, toFile: archiveFilePath(task: "CategoryStore.plist"))
  }
  func sort() {
    sortedNotes = []
    for _ in categories {
      sortedNotes.append([])
    }
    
    for note in notes {
      sortedNotes[note.categoryIndex].append(note)
    }
    for category in 0..<categories.count {
      
      sortedNotes[category].sort { $0.priority > $1.priority }
     }
  }
  
  // Mark: - PRivate Functions
  fileprivate func archiveFilePath(task: String) -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentDirectory = paths.first!
    let path = (documentDirectory as NSString).appendingPathComponent(task)
    return path
  }
  
}
