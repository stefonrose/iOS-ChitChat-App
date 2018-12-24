//
//  ChatVC.swift
//  Parse Chat
//
//  Created by Stephon Fonrose on 12/20/18.
//  Copyright © 2018 Stephon Fonrose. All rights reserved.
//

import UIKit
import Parse

class ChatVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    @IBOutlet weak var chatMessageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var messages: [PFObject?] = []
    var totalMessages: NSInteger = 0
    var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ChatVC.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        tableView.separatorStyle = .none
        tableView.scrollsToTop = true
        checkForNewMessages()
        tableView.reloadData()
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.checkForNewMessages), userInfo: nil, repeats: true)
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        checkForNewMessages()
        tableView.reloadData()
        refreshControl.endRefreshing()    }
    
    func fetchMessages() {
        let query = PFQuery(className: "Message")
        query.addDescendingOrder("createdAt")
        query.limit = 10
        query.includeKeys(["user", "createdAt"])
        query.findObjectsInBackground { (messages, error) in
            if let messages = messages {
                self.messages = messages
                self.tableView.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func loadMoreMessages(alreadyLoaded: NSInteger) {
        let query = PFQuery(className: "Message")
        query.addDescendingOrder("createdAt")
        query.limit = 10
        query.skip = messages.count
        query.includeKeys(["user", "createdAt"])
        query.findObjectsInBackground { (messages, error) in
            if let messages = messages {
                for message in messages {
                    self.messages.append(message)
                }
                self.tableView.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    @objc func checkForNewMessages() {
        let query = PFQuery(className: "Message")
        query.countObjectsInBackground { (count, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                let foundMessages = NSInteger(count.description)!
                if foundMessages > self.totalMessages {
                    self.totalMessages = foundMessages
                    self.fetchMessages()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        cell.message = messages[indexPath.row]
        cell.selectionStyle = .none
        print("Message #\(indexPath.row+1) loaded")
        if indexPath.row == messages.count - 1 {
            if totalMessages > messages.count {
                loadMoreMessages(alreadyLoaded: messages.count)
            }
        }

        return cell
    }
    
    
    @IBAction func onSend(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = chatMessageField.text ?? ""
        chatMessage["user"] = PFUser.current()
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.chatMessageField.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
}
