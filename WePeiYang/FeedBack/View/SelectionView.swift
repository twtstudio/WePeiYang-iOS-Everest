//
//  SelectionView.swift
//  WePeiYang
//
//  Created by Zrzz on 2020/11/27.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit

class SelectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    private let cellId = "SELECTION_VIEW_CELL_ID" // Cell 注册ID
    private var selectedIdx: Int = -1 // -1 则为不选择
    private var data: [String] // 数据
    private var callBack: ((Int)->Void)? // 回调函数
    // 是否能够取消选择
    var allowsCancelSelection: Bool = false
    
    init(data: [String], collectionViewLayout: UICollectionViewFlowLayout, callBack: ((Int)->Void)? = nil) {
        self.data = data
        self.callBack = callBack
        
        super.init(frame: .zero, collectionViewLayout: collectionViewLayout)
        register(FBTagCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        showsHorizontalScrollIndicator = false
        backgroundColor = .white
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FBTagCollectionViewCell
        cell.update(by: data[indexPath.row], selected: indexPath.row == selectedIdx)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if callBack != nil {
            callBack!(allowsCancelSelection && selectedIdx == indexPath.row ? -1 : indexPath.row)
        }
        
        if selectedIdx == -1 {
            selectedIdx = indexPath.row
            (collectionView.cellForItem(at: indexPath) as! FBTagCollectionViewCell).toggle()
        } else if selectedIdx == indexPath.row {
            if allowsCancelSelection {
                selectedIdx = -1
                (collectionView.cellForItem(at: indexPath) as! FBTagCollectionViewCell).toggle()
            }
            return
        } else {
            if let cell = collectionView.cellForItem(at: IndexPath(item: selectedIdx, section: indexPath.section)) {
                (cell as! FBTagCollectionViewCell).toggle()
            }
            (collectionView.cellForItem(at: indexPath) as! FBTagCollectionViewCell).toggle()
            selectedIdx = indexPath.row
        }
    }
}

// 外部调用方法
extension SelectionView {
    func getIdx() -> Int {
        return selectedIdx
    }
    
    func addCallBack(_ callBack: @escaping ((Int)->Void)) {
        self.callBack = callBack
    }
    
    func updateData(data: [String]) {
        self.data = data
        reloadData()
    }
}
