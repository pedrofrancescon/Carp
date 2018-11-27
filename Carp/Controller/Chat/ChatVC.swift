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
    private var popUpView: PopUpView!
    
    private var messages: [Message]
    private var user: CarpUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputContainerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 48)
        view.addSubview(inputContainerView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
    }
    
    private func insertNewMessage(_ message: Message) {
        
        if messages.contains(where: { $0.messageId == message.messageId } ) {
            return
        }
        
        messages.append(message)
        //messages.sort()
        
//        let isLatestMessage = messages.index(of: message) == (messages.count - 1)
//        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
        
        messagesCollectionView.reloadData()
        
//        if shouldScrollToBottom {
//            DispatchQueue.main.async {
//                self.messagesCollectionView.scrollToBottom(animated: true)
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let parent = parent as? CarVC {
            if let popView = parent.popUpView {
                self.popUpView = popView
            } else {
                debugPrint("Could not get PopUpView from parent ViewController")
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let newFrame = CGRect(x: popUpView.frame.origin.x,
                                  y: RootNavigationController.main.navigationBar.frame.height,
                                  width: popUpView.frame.width,
                                  height: RootVC.main.view.frame.height - keyboardSize.height - RootNavigationController.main.navigationBar.frame.height)
            
            popUpView.updateFrameTo(newFrame)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
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

        messages.append(newMessage)
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
}
