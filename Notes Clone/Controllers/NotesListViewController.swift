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
    
    override func viewWillAppear(_ animated: Bool) {
        loadNotes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // Init new List item
        let newNote = List(context: context)
        newNote.noteName = "New Note"
        newNote.note?.parentList = newNote.value(forKey: "noteName") as? List
        newNote.noteID = UUID()
        
        // Add new note to notesList and Context
        notesList.append(newNote)
        saveNote()
        
        // Segue to Note
//        performSegue(withIdentifier: "goToNote", sender: self)
    }
    
    // MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteReusableID", for: indexPath)
        cell.textLabel?.text = notesList[indexPath.row].noteName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToNote", sender: self)
    }
    
    // MARK: - Navigation
    
    // FIXME: Does not pass over parentage
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let destinationVC = segue.destination as! NoteViewController
        // Pass the selected object to the new view controller.
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedNote = notesList[indexPath.row].noteID
        }
    }
    
    //MARK: - CoreData Manipulation Methods
    
    func saveNote() {
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