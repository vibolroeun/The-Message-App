//
//  CollectionReference.swift
//  The Message App
//
//  Created by Vibol's Macbook Pro on 1/1/19.
//  Copyright © 2019 Vibol Roeun. All rights reserved.
//

import Foundation
import FirebaseFirestore


enum FCollectionReference: String {
    
    case User
    case Typing
    case Recent
    case Message
    case Group
    case Call
    
}

func reference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}


