//
//  ModulesSettingsViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2018/3/3.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

enum Module: String {
    case gpa = "GPA"
    case library = "图书馆"
    case classtable = "课程表"
    case ecard = "校园卡"
}

let ModuleArrangementKey = "ModuleArrangementKey"
class ModulesSettingsViewController: UIViewController {

    var tableView: UITableView!
    var modules: [(Module, Bool)] = []
    var dataChanged: Bool = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
//        self.navigationController?.navigationBar.isHidden = false
//        self.navigationController?.navigationBar.isHidden = false
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if dataChanged {
            var dict: [String: [String: String]] = [:]
            for (index, module) in modules.enumerated() {
                dict[module.0.rawValue] = ["isOn": module.1.description, "order": index.description]
            }
            UserDefaults.standard.set(dict, forKey: ModuleArrangementKey)
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

        modules = [(.classtable, true), (.gpa, true), (.library, true)]
        if let dict = UserDefaults.standard.dictionary(forKey: ModuleArrangementKey) as? [String: [String: String]] {
            var array: [(Module, Bool, Int)] = []
            for item in dict {
                array.append((Module(rawValue: item.key)!, Bool(item.value["isOn"]!)!, Int(item.value["order"]!)!))
            }
            modules = array.sorted(by: { $0.2 < $1.2 }).map({ ($0.0, $0.1) })
        }

//        modules = array

        self.view.addSubview(tableView)
    }

    @objc func switchValueChanged(sender: UISwitch) {
        if let cell = sender.superview as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
            modules[indexPath.row].1 = sender.isOn
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
        stateSwitch.isOn = module.1
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

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
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
    }

}
