//
//  IncomingMessage.swift
//  The Message App
//
//  Created by Vibol's Macbook Pro on 1/6/19.
//  Copyright © 2019 Vibol Roeun. All rights reserved.
//

import Foundation
import JSQMessagesViewController

class IncomingMessage {
    
    var collectionView: JSQMessagesCollectionView
    
    init(collectionView_: JSQMessagesCollectionView) {
        collectionView = collectionView_
    }
    
    //MARK: CreateMessage
    func createMessage(messageDictionary: NSDictionary, chatRoomId: String) -> JSQMessage? {
        
        var message: JSQMessage?
        let type = messageDictionary[kTYPE] as! String
        
        switch type {
        case kTEXT:
            //create text message
            message = createTextMessage(messageDictionary: messageDictionary, chatRoomId: chatRoomId)
        case kPICTURE:
            //create pic message
            print("pic message")
        case kAUDIO:
            //create audio message
            print("audio message")
        case kLOCATION:
            //create location message
            print("location message")
            
        default:
            print("Unknown message type")
        }
        
        if message != nil {
            return message
        }
        return nil
    }
    
    
    //MARK: Create Message types
    
    func createTextMessage(messageDictionary: NSDictionary, chatRoomId: String) -> JSQMessage {
        
        let name = messageDictionary[kSENDERNAME] as? String
        let userId = messageDictionary[kSENDERID] as? String
        
        var date: Date!
        if let created = messageDictionary[kDATE] {
            if (created as! String).count != 14 {
                date = Date()
            } else {
                date = dateFormatter().date(from: created as! String)
            }
        } else {
            date = Date()
        }
        
        let text = messageDictionary[kMESSAGE] as! String
        
        return JSQMessage(senderId: userId, displayName: name, text: text)
        
    }
    
}


