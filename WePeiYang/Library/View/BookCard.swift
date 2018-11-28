//
//  BookView.swift
//  WePeiYang
//
//  Created by 毛线 on 2018/10/30.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SDWebImage

class BookCard: CardView {
    var book: LibraryBook? {
        didSet {
            if let book = book {
                titleLabel.text = book.title.replacingOccurrences(of: "/", with: "")
                labelTexts[0] = "  作者  " + book.author
                labelTexts[1] = "  书号  " + book.callno
                labelTexts[2] = "  借阅日期  " + book.loanTime.replacingOccurrences(of: "-", with: "/")
                for i in 0...2 {
                    labels[i].attributedText = makeupLabelText(label: labels[i], img: labelImages[i], str: labelTexts[i])
                }
                
                if calculateDay(returnTime: book.returnTime) >= 0 {
                    labelTexts[3] = "  剩余天数  " + "\(calculateDay(returnTime: book.returnTime) + 1)" + "天"
                    labels[3].attributedText = makeupLabelText(label: labels[3], img: labelImages[3], str: labelTexts[3])
                } else {
                    labelTexts[3] = "  剩余天数  超出" + "\(-calculateDay(returnTime: book.returnTime))" + "天"
                    let range = NSRange(location: 7, length: labelTexts[3].count - 6)
                    let str = makeupLabelText(label: labels[3], img: labelImages[3], str: labelTexts[3])
                    str.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(r: 245, g: 45, b: 74), range: range)
                    labels[3].attributedText = str
                }
                
                LibraryBook.getImage(id: "\(book.id)", success: {
                    link in
                    self.bookImage.sd_setImage(with: URL(string: link), placeholderImage: #imageLiteral(resourceName: "暂无图片"))
                }, failure: {
                    self.bookImage.image = #imageLiteral(resourceName: "暂无图片")
                })
            }
        }
    }
    private let bookImage = UIImageView()
    private let titleLabel = UILabel()
    private var labels: [UILabel] = []
    private let labelImages = [#imageLiteral(resourceName: "个人中心"), #imageLiteral(resourceName: "日历"), #imageLiteral(resourceName: "出版"), #imageLiteral(resourceName: "时间")]
    private var labelTexts: [String] = ["  作者  ", "  书号  ", "  借阅日期  ", "  剩余天数  "]
    private let innerpadding: CGFloat = UIScreen.main.bounds.height * 0.02
    private let padding: CGFloat = UIScreen.main.bounds.width * 0.2
    private let bottomPadding: CGFloat = UIScreen.main.bounds.height * 0.05
    
    override func initialize() {
        super.initialize()
        self.backgroundColor = .white
        bookImage.contentMode = .scaleAspectFit
        contentView.addSubview(bookImage)
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        titleLabel.numberOfLines=0
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
        contentView.addSubview(titleLabel)
        titleLabel.sizeToFit()
        
        makeupLabel()
        remakeConstraints()
    }
    
    func makeupLabel() {
        for i in 0..<4 {
            labels.append(UILabel())
            labels[i].font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
            labels[i].textColor = UIColor(red: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1)
            contentView.addSubview(labels[i])
            labels[i].sizeToFit()
            labels[i].attributedText = makeupLabelText(label: labels[i], img: labelImages[i], str: labelTexts[i])
            labels[i].snp.makeConstraints { (make) -> Void in
                make.width.equalTo(190)
                make.centerX.equalTo(contentView.snp.centerX)
            }
        }
        for i in 1..<4 {
            labels[i].snp.makeConstraints { (make) -> Void in
                make.top.equalTo(labels[i-1].snp.bottom).offset(innerpadding)
                make.height.equalTo(labels[i-1])
            }
        }
        labels[3].snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(contentView).offset(-bottomPadding)
        }
    }
    
    private func makeupLabelText(label: UILabel, img: UIImage, str: String) -> NSMutableAttributedString {
        let image = NSTextAttachment()
        image.image = img
        image.bounds = CGRect(x: 0, y: -2, width: (label.font.lineHeight), height: (label.font.lineHeight))
        let imageStr = NSAttributedString(attachment: image)
        let string = NSAttributedString(string: str, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        let allStr = NSMutableAttributedString()
        allStr.append(imageStr)
        allStr.append(string)
        return allStr
    }
    
    private func remakeConstraints() {
        contentView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bookImage.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(contentView)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.45)
            make.top.equalTo(contentView).offset(bottomPadding / 2)
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(contentView)
            make.width.equalTo(contentView).multipliedBy(0.82)
            make.top.equalTo(bookImage.snp.bottom).offset(innerpadding)
            make.bottom.equalTo(labels[0].snp.top).offset(-innerpadding)
        }
    }
}

extension BookCard {
    func calculateDay(returnTime: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let returnDate = dateFormatter.date(from: returnTime)
        let between = Calendar.current.dateComponents([.day], from: Date(), to: returnDate!)
        return between.day ?? 0
    }
}

extension LibraryBook {
    static func getImage(id: String, success: ((String) -> Void)? = nil, failure: @escaping () -> Void) {
        SolaSessionManager.solaSession(url: "/library/book/" + id, success: { dict in
            let data = dict["data"] as? [String: Any]
            if let isbn = data!["isbn"] as? String {
                self.sendIsbn(parameters: ["isbns": isbn], success: {
                    imageDict in
                    if let result = imageDict["result"] as? [[String: Any]] {
                        if !(result.isEmpty) {
                            if let link = result[0]["coverlink"] {
                                success?(link as! String)
                                return
                            }
                        }
                    }
                    failure()
                }, failure: {
                    _ in
                    failure()
                })
            }
        }, failure: { _ in
            failure()
        })
    }
    
    static func sendIsbn(parameters: [String: String]? = nil, success: @escaping ([String: Any]) -> Void, failure: @escaping (Error) -> Void) {
        let isbn = parameters!["isbns"] ?? ""
        Alamofire.request("https://vote.twtstudio.com/getImgs.php?isbns=" + "\(isbn)", method: .post, parameters: parameters, headers: nil).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.result.value {
                    if let dict = data as? [[String: Any]] {
                        success(dict[0])
                        return
                    }
                }
                let error = response.error ?? WPYCustomError.errorCode(-2, "数据解析错误")
                failure(error)
            case .failure(let error):
                if let data = response.result.value {
                    if let dict = data as? [String: Any],
                        let errmsg = dict["message"] as? String {
                        failure(WPYCustomError.custom(errmsg))
                        return
                    }
                }
                failure(error)
            }
        }
    }
}
