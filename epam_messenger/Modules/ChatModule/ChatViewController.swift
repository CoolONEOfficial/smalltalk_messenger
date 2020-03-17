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
    
    var deleteButton = UIButton()
    var forwardButton = UIButton()
    let stack = UIStackView()
    
    open lazy var autocompleteManager: AutocompleteManager = { [unowned self] in
        let manager = AutocompleteManager(for: self.inputBar.inputTextView)
        
        manager.defaultTextAttributes[.foregroundColor] = UIColor.plainText
        self.inputBar.inputTextView.textColor = UIColor.plainText
        
        manager.delegate = self
        manager.dataSource = self
        return manager
        }()
    
    private var keyboardManager = KeyboardManager()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.getChatModel().name
        
        setupTableView()
        setupInputBar()
        setupKeyboardManager()
        setupEditModeButtons()
    }
    
    private func setupEditModeButtons() {
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.addTarget(self, action: #selector(ChatViewController.deleteSelectedMessages), for: .touchUpInside)
        
        forwardButton.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        forwardButton.addTarget(self, action: #selector(ChatViewController.forwardSelectedMessages), for: .touchUpInside)
        
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.addArrangedSubview(forwardButton)
        stack.addArrangedSubview(deleteButton)
    }
    
    private func setupInputBar() {
        inputBar.delegate = self
        view.addSubview(inputBar)
    }
    
    private func setupTableView() {
        tableView.register(cellType: MessageCell.self)
        tableView.delegate = self
        tableView.allowsMultipleSelection = false
        tableView.allowsMultipleSelectionDuringEditing = true
        
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
    
    private func setupKeyboardManager() {
        keyboardManager.bind(inputAccessoryView: inputBar)
        keyboardManager.bind(to: tableView)
        
        keyboardManager.on(event: .didShow) { [weak self] _ in
            self?.tableView.scrollToBottom()
        }
        
        // Add some extra handling to manage content inset
        keyboardManager.on(event: .didChangeFrame) { [weak self] (notification) in
            
            let barHeight = self?.inputBar.bounds.height ?? 0
            self?.tableView.contentInset.bottom = notification.endFrame.height - 35
            self?.tableView.scrollIndicatorInsets.bottom = notification.endFrame.height - 35
        }.on(event: .didHide) { [weak self] _ in
            //let barHeight = self?.inputBar.bounds.height ?? 0
            self?.tableView.contentInset.bottom = 0
            self?.tableView.scrollIndicatorInsets.bottom = 0
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
    
}
