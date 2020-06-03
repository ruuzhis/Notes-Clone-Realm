//
//  ViewController.swift
//  Notes Clone
//
//  Created by Rudolfs Locmelis on 17/05/2020.
//  Copyright © 2020 Rudolfs Locmelis. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UIViewController {
    
    var selectedNote: List? {
        didSet {
            if selectedNote?.note != nil {
                loadNote()
            } else {
                newNote()
            }
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var noteEntity = [Note]()
    
    @IBOutlet weak var noteTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTextView.delegate = self
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        if let loadedText = noteEntity.first?.noteText {
            noteTextView.text = loadedText
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        textViewDidEndEditing(noteTextView)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        textViewDidEndEditing(noteTextView)
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveNote() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
    }
    
    func loadNote() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let savedNotePredicate = NSPredicate(format: "noteListed.noteName == %@", selectedNote!.noteName!)
        
        request.predicate = savedNotePredicate
        
        do {
            noteEntity = try context.fetch(request)
        } catch {
            print("Error fetching through context, \(error)")
        }
    }
    
    
    func newNote() {
        // Set up Entity within Context
        let newNote = Note(context: context)
        
        // Set up Entity properties from the ViewController
        newNote.noteText = ""
        newNote.noteListed = selectedNote
        
        // Commit newNote to Entity
        noteEntity.append(newNote)
        saveNote()
    }
    
    func saveEditedNote() {
        if let editedNote = noteEntity.first {
            editedNote.setValue(noteTextView.text, forKey: "noteText")
            selectedNote?.setValue(noteTextView.text, forKey: "noteName")
        }
        
        saveNote()
    }
    
    
}

//MARK: - UITextView Delegate Methods

extension NoteViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            textView.resignFirstResponder()
        }
        saveEditedNote()
    }
}
