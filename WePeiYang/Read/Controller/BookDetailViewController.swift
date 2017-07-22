//
//  ViewController.swift
//  TableView
//
//  Created by Kyrie Wei on 10/25/16.
//  Copyright © 2016 Kyrie Wei. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let detailTableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var currentBook: Book? = nil
    var bookID: String = ""
    var dataLoaded: Bool = false
    let placeHolderView = UIImageView(image: UIImage(named: "bookDetailPlaceholder"))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.estimatedRowHeight = 50
        detailTableView.rowHeight = UITableViewAutomaticDimension
        detailTableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.view.addSubview(detailTableView)
        placeHolderView.frame = self.view.frame
        placeHolderView.contentMode = .scaleAspectFit
        detailTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        
        if !dataLoaded {
            self.view.addSubview(placeHolderView)
            Librarian.getBookDetail(withID: bookID) {
                book in
                self.currentBook = book
                self.dataLoaded = true
                self.placeHolderView.removeFromSuperview()
                //            self.viewDidLoad()
                self.detailTableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .readRed), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if dataLoaded {
            return 3
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataLoaded {
            switch section {
            case 0:
                return 0
            case 1:
                guard self.currentBook != nil else {
                    return 0
                }
                return self.currentBook!.status.count
            case 2:
                guard self.currentBook != nil else {
                    return 0
                }
                return self.currentBook!.reviews.count
            default:
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1{
            if self.currentBook!.status.count != 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "StatusInfoCell") {
                    return cell
                }
                let cell = StatusInfoCell(status: self.currentBook!.status[indexPath.row].statusInLibrary , callno: self.currentBook!.status[indexPath.row].callno , location: self.currentBook!.status[indexPath.row].library, duetime: self.currentBook!.status[indexPath.row].dueTime)
                return cell
            }
            
        } else if indexPath.section == 2 {
            //书评
            if self.currentBook!.reviews.count != 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") {
                    return cell
                }
                let cell = ReviewCell(model: self.currentBook!.reviews[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return UIScreen.main.bounds.height + 100
        case 1:
            return 47
        case 2:
            return 30
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0: return {
            guard self.currentBook != nil else {
                let foo = UIImageView(image: UIImage(named: "bookDetailPlaceholder"))
                foo.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                foo.contentMode = .scaleAspectFit
                return foo
            }
            
            let headerView = CoverView(book: self.currentBook!)
            return headerView
            }()
        case 1: return {
            let headerView = UIView()
            headerView.backgroundColor = UIColor(red: 247/255.0, green:247/255.0, blue:247/255.0, alpha:1.0)
            let viewOfLabels = UIView()
            viewOfLabels.backgroundColor = .white
            
            let headerLabel = UILabel()
            headerLabel.text = "在馆信息"
            headerLabel.font = UIFont(name: "Futura", size: 17)
            headerLabel.textColor = UIColor.lightGray
            headerLabel.sizeToFit()
            headerView.addSubview(headerLabel)
            headerLabel.snp.makeConstraints{
                make in
                make.left.equalTo(headerView).offset(16)
                make.top.equalTo(headerView).offset(5)
            }
            
            let callno = UILabel()
            callno.text = "索书号"
            callno.font = UIFont(name: "Futura", size: 14)
            callno.textAlignment = .center
            callno.textColor = UIColor.lightGray
            //            headerView.addSubview(callno)
            //            callno.snp.makeConstraints{
            //                make in
            //                make.left.equalTo(headerView)
            //                make.right.equalTo(headerView).offset((-self.view.frame.size.width / 3) * 2)
            //                make.bottom.equalTo(headerView)
            //            }
            viewOfLabels.addSubview(callno)
            callno.snp.makeConstraints {
                make in
                make.top.equalTo(viewOfLabels.snp.top)
                make.bottom.equalTo(viewOfLabels.snp.bottom)
                make.left.equalTo(viewOfLabels).offset(16)
            }
            
            let locationLabel = UILabel()
            locationLabel.text = "所在馆藏地点"
            locationLabel.textAlignment = .center
            locationLabel.font = UIFont(name: "Futura", size: 14)
            locationLabel.textColor = UIColor.lightGray
            locationLabel.backgroundColor = UIColor.white
            //            headerView.addSubview(locationLabel)
            //            locationLabel.snp.makeConstraints{
            //                make in
            //                make.left.equalTo(callno.snp.right)
            //                make.right.equalTo(headerView).offset(-self.view.frame.size.width / 3)
            //                make.centerY.equalTo(callno.snp.centerY)
            //            }
            viewOfLabels.addSubview(locationLabel)
            locationLabel.snp.makeConstraints {
                make in
                make.top.equalTo(viewOfLabels.snp.top)
                make.bottom.equalTo(viewOfLabels.snp.bottom)
                make.centerX.equalTo(viewOfLabels.snp.centerX)
            }
            
            let statusLabel = UILabel()
            statusLabel.text = "在馆状态"
            statusLabel.textAlignment = .center
            statusLabel.font = UIFont(name: "Futura", size: 14)
            statusLabel.textColor = UIColor.lightGray
            statusLabel.backgroundColor = UIColor.white
            //            headerView.addSubview(statusLabel)
            //            statusLabel.snp.makeConstraints{
            //                make in
            //                make.left.equalTo(locationLabel.snp.right)
            //                make.right.equalTo(headerView)
            //                make.centerY.equalTo(callno.snp.centerY)
            //            }
            viewOfLabels.addSubview(statusLabel)
            statusLabel.snp.makeConstraints {
                make in
                make.top.equalTo(viewOfLabels.snp.top)
                make.bottom.equalTo(viewOfLabels.snp.bottom)
                make.right.equalTo(viewOfLabels.snp.right).offset(-16)
            }
            
            headerView.addSubview(viewOfLabels)
            viewOfLabels.snp.makeConstraints {
                make in
                make.left.right.equalTo(headerView)
                make.top.equalTo(headerLabel.snp.bottom).offset(8)
                
            }
            
            return headerView
            
            }()
        case 2: return {
            let headerView = UIView()
            headerView.backgroundColor = UIColor(red: 247/255.0, green:247/255.0, blue:247/255.0, alpha:1.0)
            
            let headerLabel2 = UILabel()
            headerLabel2.text = "全部书评"
            headerLabel2.font = UIFont(name: "Futura", size: 17)
            headerLabel2.textColor = UIColor.lightGray
            headerView.addSubview(headerLabel2)
            headerLabel2.snp.makeConstraints{
                make in
                make.left.equalTo(headerView).offset(16)
                make.top.equalTo(headerView).offset(5)
            }
            return headerView
            }()
        default:
            return nil
        }
    }
    
    func reloadReview() {
        Librarian.getBookDetail(withID: "\(currentBook!.id)") {
            book in
            self.currentBook?.reviews = book.reviews
            self.detailTableView.reloadData()
        }
    }
    
}

extension BookDetailViewController {
    convenience init(bookID: String) {
        self.init()
        self.bookID = bookID
        //TODO: FIX THE CRASH WHEN NO DATA WAS FETCHED
    }
    
    convenience init(book: Book) {
        self.init()
        self.currentBook = book
        self.dataLoaded = true
        placeHolderView.removeFromSuperview()
        self.detailTableView.reloadData()
    }
}

extension BookDetailViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        self.navigationController?.navigationController?.navigationBar.alpha = y/(UIScreen.main.bounds.height * 0.52)
//        self.navigationController?.jz_navigationBarBackgroundAlpha = y / (UIScreen.main.bounds.height * 0.52)
        if y > (UIScreen.main.bounds.height * 0.52) {
            //改变 statusBar 颜色
            self.navigationController?.navigationBar.barStyle = .default
//            UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
            if let _ = self.navigationController {
                self.navigationController!.navigationBar.tintColor = nil
            }

        } else {
            self.navigationController?.navigationBar.barStyle = .black
//            UIApplication.shared.setStatusBarStyle(.LightContent, animated: true)
            if let _ = self.navigationController {
                self.navigationController!.navigationBar.tintColor = UIColor.white
            }
        }
    }

    
}
