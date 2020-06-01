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
    
    var selectedNote: UUID? {
        didSet {
            loadNote()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var noteEntity = [Note]()
    
    @IBOutlet weak var noteTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        noteTextView.delegate = self
        
        newNote()
    }
        
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        newNote()
        textViewDidEndEditing(noteTextView)
    }
    
    
    
    //MARK: - Model Manipulation Methods
    
    // FIXME: Saves twice
    func saveNote() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
    }
    
    func loadNote() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        
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
        newNote.noteText = noteTextView.text
        newNote.parentList?.noteID = selectedNote
        
        // Commit newNote to Entity
        if noteEntity.count != 0 {
            noteEntity.removeAll()
        }
        noteEntity.append(newNote)
    }
}

//MARK: - UITextView Delegate Methods

extension NoteViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            textView.resignFirstResponder()
        }
        saveNote()
    }
}
