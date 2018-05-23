//
//  FoodCatalogueTableViewCell.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/5/3.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class FoodCatalogueTableViewCell: UITableViewCell {
    
    var view: UIView!
    var label: UILabel!
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        label = UILabel(frame: CGRect(x: 10, y: 10, width: 60, height: 40))
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(red: 130/255.0, green: 130/255.0, blue: 130/255.0, alpha: 1)
        label.highlightedTextColor = .yellow
        
        view = UIView(frame: CGRect(x: 0, y: 5, width: 5, height: 45))
        view.backgroundColor = .yellow
        
        self.contentView.addSubview(label)
        self.contentView.addSubview(view)
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.contentView.backgroundColor = selected ? UIColor.white : UIColor(white: 0, alpha: 0.1)
        self.isHighlighted = selected
        self.label.isHighlighted = selected
        self.view.isHidden = !selected
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
