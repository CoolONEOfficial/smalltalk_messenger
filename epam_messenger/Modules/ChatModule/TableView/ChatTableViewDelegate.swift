//
//  ChatTableViewDelegate.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 15.03.2020.
//

import UIKit

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let date = self.tableView.chatDataSource.messageItems[section].key
        let dateString = Message24HourDateFormatter.shared.string(from: date)
        
        let label = DateHeaderLabel()
        label.text = dateString
        
        let containerView = UIView()
        
        containerView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        return containerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // MARK: - Context menu
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = NSMutableArray(array: [
            indexPath.row,
            indexPath.section
        ])
        let config = UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { _ in
            let delete = UIAction(
                title: "Delete",
                image: UIImage(systemName: "trash.fill"),
                attributes: .destructive
            ) { _ in
                self.viewModel.deleteMessage(
                    self.tableView.chatDataSource
                        .messageItems[indexPath.section]
                        .value[indexPath.row],
                    completion: {_ in }
                )
            }
            
            return UIMenu(title: "", children: [delete])
        }
        
        return config
    }
    
    func makeTargetedPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        let identifier = configuration.identifier as! NSArray
        let indexPath = IndexPath(
            row: identifier[0] as! Int,
            section: identifier[1] as! Int
        )
        
        
        let messageCell: MessageCell = tableView.cellForRow(at: indexPath) as! MessageCell
        
        switch messageCell.messageContent {
        case let textContent as MessageTextContent:
            let parameters = UIPreviewParameters()
            parameters.backgroundColor = textContent.textMessage.isIncoming
                ? .plainBackground
                : .accent
            
            let bounds = textContent.textLabel.bounds.inset(
                by: .init(
                    top: -5,
                    left: -5,
                    bottom: -5,
                    right: -5
                )
            )
           
            parameters.visiblePath = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
            
            return UITargetedPreview(view: textContent.textLabel, parameters: parameters)
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
    }
    
    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
    }
}
