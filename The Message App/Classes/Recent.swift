//
//  Recent.swift
//  The Message App
//
//  Created by Vibol's Macbook Pro on 1/3/19.
//  Copyright © 2019 Vibol Roeun. All rights reserved.
//

import Foundation

func startPrivateChat(user1: FUser, user2: FUser) -> String {
    
    let userId1 = user1.objectId
    let userId2 = user2.objectId
    
    var chatRoomId = ""
    
    let value = userId1.compare(userId2).rawValue
    
    if value < 0 {
        chatRoomId = userId1 + userId2
    }else{
        
        chatRoomId = userId2 + userId1
    }
    
    let members = [userId1, userId2]
    
    //creat recent chats
    createRecent(members: members, chatRoomId: chatRoomId, withUserUserName: "", type: kPRIVATE, users: [user1, user2], avatarOfGroup: nil)
    
    return chatRoomId
}

func createRecent(members: [String], chatRoomId: String, withUserUserName: String, type: String, users: [FUser]?, avatarOfGroup: String?) {
    
    var tempMembers = members
    
    reference(.Recent).whereField(kCHARTROOMID, isEqualTo: chatRoomId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else { return }
        
        if !snapshot.isEmpty {
            
            for recent in snapshot.documents {
                
                let currentRecent = recent.data() as NSDictionary
                
                if let currentUserId = currentRecent[kUSERID] {
                    if tempMembers.contains(currentUserId as! String) {
                        tempMembers.remove(at: tempMembers.index(of: currentUserId as! String)!)
                    }
                }
            }
            
        }
        
        for userId in tempMembers {
            
            createRecentItem(userId: userId, chatRoomId: chatRoomId, members: members, withUserUserName: withUserUserName, type: type, users: users, avatarOfGroup: avatarOfGroup)
            
        }
    }
}

func createRecentItem(userId: String, chatRoomId: String, members: [String], withUserUserName: String, type: String, users: [FUser]?, avatarOfGroup: String?) {
 
    let localReference = reference(.Recent).document()
    let recentId = localReference.documentID
    
    let date = dateFormatter().string(from: Date())
    var recent: [String : Any]!
    
    //private
    if type == kPRIVATE {
        var withUser: FUser?
        
        if users != nil && users!.count > 0 {
            if userId == FUser.currentId() {
                //for current user
                withUser = users!.last!
            }else{
                withUser = users!.first!
            }
        }
        
        recent = [kRECENTID : recentId, kUSERID : userId, kCHARTROOMID: chatRoomId, kMEMBERS : members, kMEMBERSTOPUSH : members, kWITHUSERFULLNAME : withUser!.fullname, kWITHUSERUSERID : withUser!.objectId, kLASTMESSAGE : "", kCOUNTER : 0, kDATE : date, kTYPE : type, kAVATAR : withUser!.avatar] as [String : Any]
        
    }else {
        //group
        
        if avatarOfGroup != nil {
            
            recent = [kRECENTID : recentId, kUSERID : userId, kCHARTROOMID : chatRoomId, kMEMBERS : members, kMEMBERSTOPUSH : members, kWITHUSERFULLNAME : withUserUserName, kLASTMESSAGE : "", kCOUNTER : 0, kDATE : date, kTYPE : type, kAVATAR : avatarOfGroup!] as [String : Any]
            
        }
        
    }
    
    //save recent chat
    localReference.setData(recent)
    
}

//Restart Chat
func restartRecentChat(recent: NSDictionary) {
    
    if recent[kTYPE] as! String == kPRIVATE {
      
        createRecent(members: recent[kMEMBERSTOPUSH] as! [String], chatRoomId: recent[kCHARTROOMID] as! String, withUserUserName: FUser.currentUser()!.firstname, type: kPRIVATE, users: [FUser.currentUser()!], avatarOfGroup: nil)
        
    }
    if recent[kTYPE] as! String == kGROUP {
        
        createRecent(members: recent[kMEMBERSTOPUSH] as! [String], chatRoomId: recent[kCHARTROOMID] as! String, withUserUserName: recent[kWITHUSERUSERNAME] as! String, type: kGROUP, users: nil, avatarOfGroup: recent[kAVATAR] as? String)
        
    }
}



// Delete recent
func deleteRecentChat(recentChatDictionary: NSDictionary) {
    
    if let recentId = recentChatDictionary[kRECENTID] {
        
        reference(.Recent).document(recentId as! String).delete()
    }
    
}



