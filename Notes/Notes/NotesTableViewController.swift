//
//  NotesTableViewController.swift
//  Notes
//
//  Created by Ben Larrabee on 10/18/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {
  
  @IBOutlet weak var filteringComplete: UISwitch!
  
  
    override func viewDidLoad() {
      super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return NoteStore.shared.currentCategoryIndex
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      print("The getCount method says \(NoteStore.shared.getCount())")
        return NoteStore.shared.getCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NoteTableViewCell.self)) as! NoteTableViewCell

      cell.setupCell(NoteStore.shared.getNote(at: indexPath.section, index: indexPath.row))

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
          NoteStore.shared.deleteNote(indexPath.section, index: indexPath.row)
          tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "EditNoteSegue" {
        let noteDetailVC = segue.destination as! NoteDetailViewController
        let tableCell = sender as! NoteTableViewCell
        noteDetailVC.note = tableCell.note
      }
    }
  // MARK: - Unwind Segue
  @IBAction func saveNoteDetail(_ segue: UIStoryboardSegue) {
    let noteDetailVC = segue.source as! NoteDetailViewController
    if let indexPath = tableView.indexPathForSelectedRow {
      NoteStore.shared.updateNote(noteDetailVC.note, category: indexPath.section, index: indexPath.row)
      NoteStore.shared.sort()
      var indexPaths: [IndexPath] = []
      for index in 0...indexPath.row{
        indexPaths.append(IndexPath(row: index, section: 0))
      }
      
      tableView.reloadRows(at: indexPaths, with: .automatic)
    } else {
      NoteStore.shared.addNote(noteDetailVC.note)
      
      
      let indexPath = IndexPath(row: 0, section: 0)
      tableView.insertRows(at: [indexPath], with: .automatic)
    }
  }  
}
