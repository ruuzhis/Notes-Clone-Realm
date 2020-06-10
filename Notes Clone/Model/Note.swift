//
//  Note.swift
//  Notes Clone Realm
//
//  Created by Rudolfs Locmelis on 08/06/2020.
//  Copyright © 2020 Rudolfs Locmelis. All rights reserved.
//

import Foundation
import RealmSwift

class Note: Object {
    @objc dynamic var noteText: String = ""
    @objc dynamic var noteListed: NotesList?
}
