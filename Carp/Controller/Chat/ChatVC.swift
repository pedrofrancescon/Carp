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

class ChatVC: MessagesViewController {

    private let inputContainerView: UIView
    
    var messages: [Message]
    var user: CarpUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputContainerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 48)
        view.addSubview(inputContainerView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            guard let parent = parent as? CarVC else { return }
            guard let popUpView = parent.popUpView else { return }
            
            if popUpView.frame.maxY == UIScreen.main.bounds.maxY {
                popUpView.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            guard let parent = parent as? CarVC else { return }
            guard let popUpView = parent.popUpView else { return }
            
            if popUpView.frame.maxY != UIScreen.main.bounds.maxY {
                popUpView.frame.origin.y += keyboardSize.height
            }
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

    init() {
        inputContainerView = UIView()
        messages = []
        user = CarpUser(id: "123", firstName: "Pedrita", lastName: "Pomposa a Sagaz", profilePictureUrl: "nil", gender: "fluid")
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
        
        return 12
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(
            string: message.sender.displayName,
            attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
}

extension ChatVC: MessagesLayoutDelegate {
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
}

extension ChatVC: MessagesDisplayDelegate {
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        _ = messages[indexPath.section]
        let color = UIColor.green
        avatarView.backgroundColor = color
    }
}

extension ChatVC: MessageInputBarDelegate {
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {

        let newMessage = Message(user: user, text: text, messageId: UUID().uuidString)

        messages.append(newMessage)
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
}
