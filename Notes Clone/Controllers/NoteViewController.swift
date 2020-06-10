//
//  ViewController.swift
//  Notes Clone
//
//  Created by Rudolfs Locmelis on 17/05/2020.
//  Copyright © 2020 Rudolfs Locmelis. All rights reserved.
//

import UIKit
import RealmSwift

class NoteViewController: UIViewController {
    
    internal var selectedNote: NotesList? {
        didSet {
            if selectedNote?.note.first != nil {
                loadNote()
            } else {
                newNote()
            }
        }
    }
    private let realm = try! Realm()
    private var noteObject = Note()
    
    @IBOutlet weak var noteTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTextView.delegate = self
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        noteTextView.text = noteObject.noteText
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if noteObject.isInvalidated {
            return
        } else {
            textViewDidEndEditing(noteTextView)
        }
    }
    
    
    //MARK: - Model Manipulation Methods
    
    func loadNote() {
        noteObject = realm.objects(Note.self).filter("noteListed == %@", selectedNote!).first!
    }
    
    //MARK: - Creating New Note
    
    func newNote() {
        try! realm.write {
            noteObject.setValuesForKeys(["noteText": "", "noteListed":  selectedNote!])
            realm.add(noteObject)
        }
    }
    
    //MARK: - Editing Existing Note
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        textViewDidEndEditing(noteTextView)
    }
    
    func saveEditedNote() {
        try! realm.write {
            noteObject.setValue(noteTextView.text, forKey: "noteText")
            selectedNote?.setValue(noteTextView.text, forKey: "noteContent")
            
            // TODO: Create Headline formatting to feed in noteName
            if noteTextView.text == "" {
                return
            } else {
                selectedNote?.setValue(noteTextView.text, forKey: "noteName")
            }
        }
    }
    
    //MARK: - ToolBar Action Methods
    
    @IBAction func trashPressed(_ sender: UIBarButtonItem) {
        do {
            try realm.write {
                realm.delete(noteObject)
                realm.delete(selectedNote!)
                navigationController?.popViewController(animated: true)
            }
        } catch {
            print("Error deleting from Realm, \(error)")
        }
        
    }
}

//MARK: - UITextView Delegate Methods

extension NoteViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        saveEditedNote()
    }
}
