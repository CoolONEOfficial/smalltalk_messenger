//
//  ChatViewController.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 08.03.2020.
//

import UIKit
import Firebase
import FirebaseUI
import CodableFirebase
import InputBarAccessoryView

class ChatViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: ChatTableView!
    @IBOutlet var bottomInsetConstraint: NSLayoutConstraint!
    
    // MARK: - Vars
    
    let inputBar: InputBarAccessoryView = ChatInputBar()
    var viewModel: ChatViewModelProtocol!
    
    open lazy var autocompleteManager: AutocompleteManager = { [unowned self] in
        let manager = AutocompleteManager(for: self.inputBar.inputTextView)
        
        manager.defaultTextAttributes[.foregroundColor] = UIColor.plainText
        
        manager.delegate = self
        manager.dataSource = self
        return manager
    }()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.getChatModel().name
        
        setupTableView()
        setupInputBar()
    }
    
    private func setupInputBar() {
        inputBar.delegate = self
    }
    
    private func setupTableView() {
        tableView.register(cellType: MessageCell.self)
        tableView.delegate = self
        
        tableView.dataSource = tableView.bind(
            toFirestoreQuery: viewModel.firestoreQuery()
        ) { tableView, indexPath in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MessageCell.self)
            
            let section = self.tableView
                .chatDataSource
                .messageItems[indexPath.section].value
            let message = section[indexPath.row]
            
            cell.loadMessage(
                message,
                mergeNext: section.count > indexPath.row + 1
                    && ChatViewController.checkMerge(left: message, right: section[indexPath.row + 1]),
                mergePrev: 0 < indexPath.row
                    && ChatViewController.checkMerge(left: message, right: section[indexPath.row - 1])
            )
            
            return cell
        }
    }
    
    private static func checkMerge(
        left: MessageProtocol,
        right: MessageProtocol
    ) -> Bool {
        return left.userId == right.userId
            && abs(left.date.timeIntervalSince(right.date)) < 60 * 5 // 5 minutes interval
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.scrollToBottom()
    }
    
    // MARK: - Input bar
    
    override var inputAccessoryView: UIView? {
        return inputBar
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

}
