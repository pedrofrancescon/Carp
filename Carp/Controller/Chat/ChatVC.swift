//
//  ChatVC.swift
//  Carp
//
//  Created by Pedro Francescon Cittolin on 13/11/18.
//  Copyright © 2018 Pedro Francescon Cittolin. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar
import Firebase

class ChatVC: MessagesViewController {

    private let inputContainerView: UIView
    
    private var messages: [Message]
    private var user: CarpUser!
    
    private let db = Firestore.firestore()
    private var reference: CollectionReference?
    private var messageListener: ListenerRegistration?
    
    private let car: Car
    
    var parentVC: CarVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = car.id else { return }
        
        reference = db.collection(["cars", id, "thread"].joined(separator: "/"))
        
        messageListener = reference?.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
        
        inputContainerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 48)
        view.addSubview(inputContainerView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
    }
    
    private func insertNewMessage(_ newMessage: Message) {
        guard !messages.contains(newMessage) else {
            return
        }
        
        messages.append(newMessage)
        messageInputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
    
    private func saveToFirebase(_ message: Message) {
        reference?.addDocument(data: message.representation) { error in
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                return
            }
            
            self.messagesCollectionView.scrollToBottom()
        }
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let message = Message(document: change.document) else {
            return
        }

        switch change.type {
        case .added:
            insertNewMessage(message)
        default:
            break
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            guard let popUpView = parentVC?.popUpView else { return }
            
            print(messagesCollectionView.frame)
            
            let newFrame = CGRect(x: popUpView.frame.origin.x,
                                  y: RootNavigationController.main.navigationBar.frame.height,
                                  width: popUpView.frame.width,
                                  height: RootVC.main.view.frame.height - keyboardSize.height - RootNavigationController.main.navigationBar.frame.height)
            
            popUpView.updateFrameTo(newFrame)
            
            print(messagesCollectionView.frame)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            guard let popUpView = parentVC?.popUpView else { return }
            popUpView.updateFrameTo(popUpView.originalFrame)
        }
    }
    
    override var inputAccessoryView: UIView? {
        return nil
    }
    
    override func viewDidLayoutSubviews() {
        layoutContainerInputView()
        
        inputContainerView.addSubview(messageInputBar)
        messageInputBar.frame = inputContainerView.bounds
    }

    init(car: Car) {
        inputContainerView = UIView()
        messages = []
        self.car = car
        user = CarpUser(id: "123",
                        firstName: "Pedrita",
                        lastName: "Pomposa a Sagaz",
                        profilePictureUrl: "nil",
                        gender: "fluid",
                        privateData: nil)
        super.init(nibName: "ChatVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutContainerInputView() {
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        inputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        inputContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: inputContainerView.frame.height).isActive = true
    }
    
}

extension ChatVC: MessagesDataSource {
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> Sender {
        return Sender(id: user.id, displayName: user.firstName)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 13
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(
            string: message.sender.displayName,
            attributes: [.font: UIFont(name: "Lato-Regular", size: 13.0)!,
                         .foregroundColor: UIColor.darkGreyChatText])
    }
}

extension ChatVC: MessagesLayoutDelegate {
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0.0, height: 15.0)
    }
    
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0.0, height: 7.0)
    }
}

extension ChatVC: MessagesDisplayDelegate {
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        avatarView.image = UIImage(named: "Uber")
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return isFromCurrentSender(message: message) ? UIColor.lightGreen : UIColor.greyChatBubble
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return UIColor.darkGreyChatText
    }
    
}

extension ChatVC: MessageInputBarDelegate {
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {

        let newMessage = Message(user: user, text: text, messageId: UUID().uuidString)
        
        saveToFirebase(newMessage)
        insertNewMessage(newMessage)
    }
}
