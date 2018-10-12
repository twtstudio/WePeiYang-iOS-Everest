//
//  ClassTableSettingViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2018/10/11.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper
import UserNotifications

let ClassTableNotificationOffsetKey = "ClassTableNotificationOffsetKey"
let ClassTableNotificationEnabled = "ClassTableNotificationEnabled"
class ClassTableSettingViewController: UIViewController {

    var tableView: UITableView!
    var notificationSwitch: UISwitch!
    var pickerView: UIPickerView!
    var offsetMin: Int = 15

    override func viewDidLoad() {
        super.viewDidLoad()

        notificationSwitch = UISwitch()
        notificationSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        notificationSwitch.isOn = UserDefaults.standard.bool(forKey: ClassTableNotificationEnabled)

        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        self.view.addSubview(tableView)
        tableView.dataSource = self
        log(tableView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped(recognizer:)))
        tableView.addGestureRecognizer(tap)

        pickerView = UIPickerView()
        self.view.addSubview(pickerView)
        pickerView.backgroundColor = .white
        pickerView.frame = CGRect(x: 0, y: view.height, width: view.width, height: 0.5 * view.height)
        pickerView.delegate = self
        pickerView.dataSource = self
        let offset = UserDefaults.standard.integer(forKey: ClassTableNotificationOffsetKey)
        offsetMin = offset == 0 ? 15 : offset
        pickerView.selectRow(offsetMin - 5, inComponent: 0, animated: true)

        tableView.reloadData()
        self.title = "课程提醒设置"
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if notificationSwitch.isOn {
            UserDefaults.standard.set(offsetMin, forKey: ClassTableNotificationOffsetKey)
            CacheManager.retreive("classtable/classtable.json", from: .group, as: String.self, success: { string in
                guard let table = Mapper<ClassTableModel>().map(JSONString: string) else {
                    return
                }
                ClassTableNotificationHelper.addNotification(table: table)
            })
        } else {
            ClassTableNotificationHelper.removeNotification()
        }
        UserDefaults.standard.set(notificationSwitch.isOn, forKey: ClassTableNotificationEnabled)
    }

    @objc func tableViewTapped(recognizer: UITapGestureRecognizer) {
        if let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)),
            cell.hitTest(recognizer.location(in: cell), with: nil) != nil {
            UIView.animate(withDuration: 0.3, animations: {
                self.pickerView.frame = CGRect(x: 0, y: 0.5 * self.view.height, width: self.view.width, height: 0.5 * self.view.height)
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.pickerView.frame = CGRect(x: 0, y: self.view.height, width: self.view.width, height: 0.5 * self.view.height)
            })
        }
    }

    @objc func stateChanged() {
        self.tableView.reloadData()
        if notificationSwitch.isOn {
            if #available(iOS 10.0, *) {
                let center = UNUserNotificationCenter.current()
                center.getNotificationSettings(completionHandler: { settings in
                    // apply for authorization
                    switch settings.authorizationStatus {
                    case .notDetermined:
                        SwiftMessages.showWarningMessage(body: "课程提醒需要开启推送权限")
                        // whatever
                        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                            if granted {
                                DispatchQueue.main.async {
                                    UIApplication.shared.registerForRemoteNotifications()
                                }
                            } else {
                                log("Push notification request failed...")
                            }
                        }
                    case .denied:
                        SwiftMessages.showErrorMessage(body: "课程提醒需要开启推送权限，请到设置中开启推送权限")
                    default:
                        break
                    }
                })
            } else {
                if UIApplication.shared.currentUserNotificationSettings?.types == .none {
                    SwiftMessages.showErrorMessage(body: "课程提醒需要开启推送权限，请到设置中开启推送权限")
                }
            }
        }
    }
}

extension ClassTableSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "\(indexPath)")
            cell.textLabel?.text = "课前提醒"
            cell.accessoryView = notificationSwitch
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "\(indexPath)")
            cell.textLabel?.text = "课前提醒时间"
            cell.detailTextLabel?.text = "课前\(offsetMin)分钟"
            cell.selectionStyle = .none
            return cell
        default:
            fatalError()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationSwitch.isOn ? 2 : 1
    }
}

extension ClassTableSettingViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 56
    }

}

extension ClassTableSettingViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 5)"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        offsetMin = row + 5
        tableView.reloadData()
    }
}
