//
//  TableViewContentController.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 11/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

internal final class TableViewContentController: NSObject, ContentController {

    // MARK: - internal Properties

    internal var tableView: UITableView?
    internal var sectionContent = [SectionContent]()

    // MARK: - internal Functions

    internal func configure(tableView: UITableView?) {
        tableView?.delegate = self
        tableView?.dataSource = self
        self.tableView = tableView
    }

    internal func reloadContent() {
        self.tableView?.reloadData()
    }

    internal func hideAdditionalCells() {
        self.tableView?.tableFooterView = UIView()
    }

    internal func showAdditionalCells() {
        self.tableView?.tableFooterView = nil
    }

    internal func set(estimatedRowHeight: CGFloat) {
        self.tableView?.rowHeight = UITableView.automaticDimension
        self.tableView?.estimatedRowHeight = estimatedRowHeight
    }

    internal func set(estimatedSectionHeaderHeight: CGFloat) {
        self.tableView?.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView?.estimatedSectionHeaderHeight = estimatedSectionHeaderHeight
    }

    internal func set(estimatedSectionFooterHeight: CGFloat) {
        self.tableView?.sectionFooterHeight = UITableView.automaticDimension
        self.tableView?.estimatedSectionFooterHeight = estimatedSectionFooterHeight
    }

    internal func register(headerFooterViewClass: AnyClass?, reuseIdentifier: String) {
        self.tableView?.register(headerFooterViewClass, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
    
    internal func select(cellContent: CellContent) {
        guard let indexPath = self.indexPath(of: cellContent) else {
            return
        }
        
        self.performSelection(on: cellContent, at: indexPath)
    }
    
    // MARK: - File Private Functions
    
    fileprivate func performSelection(on cellContent: CellContent, at indexPath: IndexPath) {
        (cellContent as? SelectableCellContent)?.select(on: self.tableView, with: self.sectionContent, at: indexPath)
        (cellContent as? ActionableCellContent)?.action()
    }
}

extension TableViewContentController: UITableViewDelegate {

    // MARK: - internal Functions

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellContent = self.cellContentFor(indexPath: indexPath)
        self.performSelection(on: cellContent, at: indexPath)
        self.tableView?.deselectRow(at: indexPath, animated: true)
    }
}

extension TableViewContentController: UITableViewDataSource {

    // MARK: - internal Functions

    internal func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfSections()
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfItems(in: section)
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = self.reuseIdentifier(for: indexPath)
        let defaultCell = UITableViewCell()
        let cell = self.tableView?.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) ?? defaultCell
        let cellContent = self.cellContentFor(indexPath: indexPath)
        (cell as? Cell)?.configure(with: cellContent)
        return cell
    }

    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerViewContent = self.sectionContent[section].headerViewContent else {
            return nil
        }
        return self.configureHeaderFooterView(for: headerViewContent)
    }

    internal func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerViewContent = self.sectionContent[section].footerViewContent else {
            return nil
        }
        return self.configureHeaderFooterView(for: footerViewContent)
    }

    // MARK: - Private Functions

    private func configureHeaderFooterView(for headerFooterViewContent: HeaderFooterViewContent) -> UITableViewHeaderFooterView? {
        let reuseIdentifier = headerFooterViewContent.reuseIdentifier
        let headerFooterView = self.tableView?.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier)
        (headerFooterView as? HeaderFooterView)?.configure(with: headerFooterViewContent)
        return headerFooterView
    }
}
