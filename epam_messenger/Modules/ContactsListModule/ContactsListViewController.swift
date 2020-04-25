//
//  ContactsListViewController.swift
//  epam_messenger
//
//  Created by Maxim on 25.03.2020.
//

import UIKit
import Firebase
import FirebaseUI
import CodableFirebase
import Reusable

protocol ContactsSelectDelegate: AnyObject {
    func didSelectUser(_ userId: String)
}

protocol ContactsListViewControllerProtocol {
}

class ContactsListViewController: UIViewController {
    
    // MARK: - Vars
    
    var db: Firestore = {
        return Firestore.firestore()
    }()
    
    var viewModel: ContactsListViewModelProtocol!
    
    var tableView: PaginatedSectionedTableView<String, ContactModel>!
    
    let searchController = UISearchController(searchResultsController: nil)
    internal var searchItems: [UserModel] = .init()
    
    weak var selectDelegate: ContactsSelectDelegate?
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isSelectMode {
            title = "Select user"
            let backItem = UIBarButtonItem()
            backItem.title = "Cancel"
            backItem.tintColor = .accent
            backItem.action = #selector(didCancelTap)
            backItem.target = self
            navigationItem.leftBarButtonItem = backItem
        }
        
        setupTableView()
    }
    
    @objc func didCancelTap() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSearchController()
        tabBarController?.title = "Contacts"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchController.searchBar.text = nil
        searchController.isActive = false
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by users"
        if let navigationItem = isSelectMode
            ? self.navigationItem
            : tabBarController?.navigationItem {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    private func setupTableView() {
        tableView = .init(
            baseQuery: viewModel.baseQuery,
            initialPosition: .top,
            cellForRowAt: { indexPath in
                let cell = self.tableView.dequeueReusableCell(for: indexPath, cellType: UserCell.self)
                let contact = self.tableView.elementAt(indexPath)
                
                cell.loadUser(
                    byId: contact.userId,
                    savedMessagesSupport: true,
                    withLocalName: contact.localName
                )
                
                return cell
            },
            querySideTransform: { contact in
                contact.localName
            },
            groupingBy: { contact in
                String(contact.localName.prefix(1))
            },
            sortedBy: { l, r in
                l > r
            },
            fromSnapshot: ContactModel.fromSnapshot
        )
        
        tableView.register(cellType: UserCell.self)
        tableView.paginatedDelegate = self
        tableView.allowsMultipleSelection = false
        tableView.allowsMultipleSelectionDuringEditing = true
        
        view.addSubview(tableView)
        tableView.edgesToSuperview()
    }
    
    // MARK: - Helpers
    
    var isSelectMode: Bool {
        return tabBarController == nil
    }
    
    var isSearch: Bool {
        return !(searchController.searchBar.text?.isEmpty ?? true)
    }
}

extension ContactsListViewController: PaginatedTableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contact = self.tableView.elementAt(indexPath)
            viewModel.deleteContact(contact.documentId!) { err in
                if let err = err {
                    self.presentErrorAlert(err.localizedDescription)
                    return
                }
            }
        }
    }
    
    public func tableView(
        _ tableView: UITableView,
        editingStyleForRowAt indexPath: IndexPath
    ) -> UITableViewCell.EditingStyle {
        isSearch
            ? .none
            : .delete
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearch {
            let user = searchItems[indexPath.row]
            if isSelectMode {
                selectDelegate?.didSelectUser(user.documentId!)
                navigationController?.dismiss(animated: true, completion: nil)
            } else {
                viewModel.didUserSelect(user)
            }
        } else {
            let contact = self.tableView.elementAt(indexPath)
            if isSelectMode {
                selectDelegate?.didSelectUser(contact.userId)
                navigationController?.dismiss(animated: true, completion: nil)
            } else {
                viewModel.didContactSelect(contact)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        header.contentView.backgroundColor = .secondarySystemBackground
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        isSearch
            ? nil
            : self.tableView.keyAt(section)
    }
    
}
extension ContactsListViewController: ContactsListViewControllerProtocol {}
