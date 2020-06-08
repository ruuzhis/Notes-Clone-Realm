//
//  LIstViewController.swift
//  Notes Clone
//
//  Created by Rudolfs Locmelis on 17/05/2020.
//  Copyright © 2020 Rudolfs Locmelis. All rights reserved.
//

import UIKit
import CoreData

class NotesListViewController: UITableViewController {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var notesList = [List]()
    private var newNoteCreated = false
    
    override func viewWillAppear(_ animated: Bool) {
        loadNotes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
    }
    
    //MARK: - Editing Notes List
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // Init new List item
        let newNote = List(context: context)
        newNote.noteName = "New Note"
        
        // Add new note to notesList and Context
        notesList.append(newNote)
        saveContext()
        
        newNoteCreated = true
                
        performSegue(withIdentifier: "goToNote", sender: self)
    }
    
    // MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteReusableID", for: indexPath)
        cell.textLabel?.text = notesList[indexPath.row].noteName
        cell.detailTextLabel?.text = notesList[indexPath.row].noteContent
        return cell
    }
    
    //MARK: - TableView Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToNote", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(notesList[indexPath.row])
            notesList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            
            saveContext()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NoteViewController
     
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedNote = notesList[indexPath.row]
        }
        
        if newNoteCreated {
            destinationVC.selectedNote = notesList.last
        }
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context to List, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadNotes() {
        let request: NSFetchRequest<List> = List.fetchRequest()
        
        do {
            notesList = try context.fetch(request)
        } catch {
            print("Could not load context for List, \(error)")
        }
        
        tableView.reloadData()
    }
}
