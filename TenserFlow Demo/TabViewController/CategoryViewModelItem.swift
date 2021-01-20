//
//  CategoryViewModelItem.swift
//  TenserFlow Demo
//
//  Created by Paras Rastogi on 19/01/21.
//

import Foundation

protocol CategoryViewModelItem {
    var type: CategoryViewModelItemType {get}
    var rowCount: Int {get}
    var sectionTitle: String {get}
}

extension CategoryViewModelItem{
    var rowCount: Int{
        return 1
    }
}
