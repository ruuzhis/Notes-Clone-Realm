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
    
    internal var selectedNote: List? {
        didSet {
            if selectedNote?.note != nil {
                loadNote()
            } else {
                newNote()
            }
        }
    }
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var noteEntity = [Note]()
    
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
    
    
    //MARK: - Model Manipulation Methods
    
    func saveContext() {
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
    
    //MARK: - Creating New Note
    
    func newNote() {
        // Set up Entity within Context
        let newNote = Note(context: context)
        
        // Set up Entity properties from the ViewController
        newNote.noteText = ""
        newNote.noteListed = selectedNote
        
        // Commit newNote to Entity
        noteEntity.append(newNote)
    }
    
    //MARK: - Editing Existing Note
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        textViewDidEndEditing(noteTextView)
    }
    
    func saveEditedNote() {
        if let editedNote = noteEntity.first {
            editedNote.setValue(noteTextView.text, forKey: "noteText")
            selectedNote?.setValue(noteTextView.text, forKey: "noteContent")
            // TODO: Create Headline formatting to feed in noteName
            if noteTextView.text == "" {
                return
            } else {
                selectedNote?.setValue(noteTextView.text, forKey: "noteName")
            }
        }
        
        saveContext()
    }
    
    //MARK: - ToolBar Action Methods
    
    @IBAction func trashPressed(_ sender: UIBarButtonItem) {
        context.delete(noteEntity.first!)
        noteEntity.removeFirst()
        
        saveContext()
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITextView Delegate Methods

extension NoteViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        saveEditedNote()
    }
}
