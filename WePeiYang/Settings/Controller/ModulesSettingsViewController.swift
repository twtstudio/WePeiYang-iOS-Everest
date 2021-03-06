//
//  ModulesSettingsViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2018/3/3.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class ModulesSettingsViewController: UIViewController {

    private var tableView: UITableView!
    private var modules: [(Module, Int)] = []
    private var dataChanged: Bool = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if dataChanged {
            updateStatus()
            var dict: [String: Int] = [:]
            for item in modules {
                dict[item.0.rawValue] = item.1
            }
            ModuleStateManager.setModules(dict: dict)
            NotificationCenter.default.post(name: NotificationName.NotificationCardOrderChanged.name, object: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: self.view.bounds)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.setEditing(true, animated: true)
        tableView.isScrollEnabled = false
        self.title = "模块管理"
//        tableView.allowsSelection = false

        modules = Array(ModuleStateManager.getAllModule()).sorted { a, b in
            return abs(a.value) < abs(b.value)
        }

        self.view.addSubview(tableView)
    }

    @objc func switchValueChanged(sender: UISwitch) {
        if let cell = sender.superview as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
            let index = abs(modules[indexPath.row].1)
            modules[indexPath.row].1 = sender.isOn ? index : -index
            dataChanged = true
        }
    }
}

extension ModulesSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modules.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let module = modules[indexPath.row]
        cell.textLabel?.text = module.0.rawValue
        let stateSwitch = UISwitch()
        stateSwitch.isOn = module.1 > 0
        stateSwitch.addTarget(self, action: #selector(switchValueChanged(sender:)), for: .valueChanged)

        cell.accessoryView = stateSwitch
        cell.editingAccessoryView = stateSwitch
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension ModulesSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard destinationIndexPath != sourceIndexPath,
            destinationIndexPath.row < modules.count,
        sourceIndexPath.row < modules.count else {
            return
        }

        dataChanged = true
        modules.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        updateStatus()
    }

    func updateStatus() {
        for (idx, _) in modules.enumerated() {
            let isOn = modules[idx].1 > 0
            let row = idx + 1
            modules[idx].1 = isOn ? row : -row
//            let indexPath = IndexPath(row: idx, section: 0)
//            if let stateSwitch = tableView.cellForRow(at: indexPath)?.accessoryView as? UISwitch {
//                let row = idx + 1
//                modules[idx].1 = stateSwitch.isOn ? row : -row
//            }
        }
    }
}
