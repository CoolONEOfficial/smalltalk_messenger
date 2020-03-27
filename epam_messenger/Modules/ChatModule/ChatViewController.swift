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
    var bottomScrollAnimationsLock = false
    @IBOutlet var floatingBottomButton: UIButton!
    
    // MARK: - Vars
    
    let inputBar: ChatInputBar = ChatInputBar()
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
        view.tintColor = .accent
        
        setupTableView()
        setupInputBar()
        setupKeyboardManager()
        setupEditModeButtons()
        setupFloatingBottomButton()
    }
    
    private func setupFloatingBottomButton() {
        floatingBottomButton.layer.cornerRadius = floatingBottomButton.bounds.width / 2
        floatingBottomButton.layer.borderWidth = 0.5
        floatingBottomButton.layer.borderColor = UIColor.plainBackground.cgColor
    }
    
    private func setupEditModeButtons() {
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.addArrangedSubview(deleteButton)
        stack.addArrangedSubview(forwardButton)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = .init(top: 5, leading: 10, bottom: 10, trailing: 10)
        
        deleteButton.contentHorizontalAlignment = .fill
        deleteButton.contentVerticalAlignment = .fill
        deleteButton.contentMode = .scaleAspectFit
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.addTarget(self, action: #selector(ChatViewController.deleteSelectedMessages), for: .touchUpInside)
        deleteButton.size(.init(width: 23, height: 25))
        
        forwardButton.contentHorizontalAlignment = .fill
        forwardButton.contentVerticalAlignment = .fill
        forwardButton.contentMode = .scaleAspectFit
        forwardButton.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        forwardButton.addTarget(self, action: #selector(ChatViewController.forwardSelectedMessages), for: .touchUpInside)
        forwardButton.size(.init(width: 30, height: 25))

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
                    && MessageModel.checkMerge(left: message, right: section[indexPath.row + 1]),
                mergePrev: 0 < indexPath.row
                    && MessageModel.checkMerge(left: message, right: section[indexPath.row - 1])
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
            //let barHeight = self?.inputBar.bounds.height ?? 0
            self?.tableView.contentInset.bottom = notification.endFrame.height - 35
            self?.tableView.verticalScrollIndicatorInsets.bottom = notification.endFrame.height - 35
        }.on(event: .didHide) { [weak self] _ in
            //let barHeight = self?.inputBar.bounds.height ?? 0
            self?.tableView.contentInset.bottom = 0
            self?.tableView.verticalScrollIndicatorInsets.bottom = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.scrollToBottom()
    }
    
    // MARK: Floating bottom button
    
    @IBAction func didFloatingBottomButtonClick(_ sender: UIButton) {
        tableView.scrollToBottom()
    }
    
}
