//
//  CourseCollectionView.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/12/1.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

class CourseCollectionView: UICollectionView {

    private var classModels: [ClassModel] = []
    weak var courseDelegate: CourseListViewDelegate?

    convenience init(classModels: [ClassModel], frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        let cellWidth = (UIScreen.main.bounds.width - 20 * 3) / 2
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.headerReferenceSize = CGSize(width: 1, height: UIScreen.main.bounds.height / 4)
        self.init(frame: frame, collectionViewLayout: layout)

        self.classModels = classModels
        self.delegate = self
        self.dataSource = self
        self.register(CourseCollectionViewCell.self, forCellWithReuseIdentifier: "CourseCollectionViewCell")
        self.backgroundColor = UIColor.white.withAlphaComponent(0.7)
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CourseCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.classModels[indexPath.item]
        courseDelegate?.collectionView(self, didSelectCourse: model)
    }
}

extension CourseCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.classModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseCollectionViewCell", for: indexPath) as! CourseCollectionViewCell
        let model = self.classModels[indexPath.item]
        cell.nameLabel.text = model.courseName
        cell.locationLabel.text = model.teacher
        if model.isDisplay == true {
            cell.contentView.backgroundColor = Metadata.Color.fluentColors[model.colorIndex].withAlphaComponent(0.7)
        } else {
            cell.contentView.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        }

        return cell
    }
}
