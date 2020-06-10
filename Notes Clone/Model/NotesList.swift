//
//  NotesList.swift
//  Notes Clone Realm
//
//  Created by Rudolfs Locmelis on 08/06/2020.
//  Copyright © 2020 Rudolfs Locmelis. All rights reserved.
//

import Foundation
import RealmSwift

class NotesList: Object {
    @objc dynamic var noteName: String = ""
    @objc dynamic var noteContent: String = ""
    let note = LinkingObjects(fromType: Note.self, property: "noteListed")
}
