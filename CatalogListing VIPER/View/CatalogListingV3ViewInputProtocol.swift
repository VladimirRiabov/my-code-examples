//
//  CatalogListingV3ViewInputProtocol.swift
//  MOBAPP_B2C
//
//  Created by Рябов Владимир Васильевич on 21.02.2022.
//

import Foundation
import UIKit

// sourcery: AutoMockable
protocol CatalogListingV3ViewInputProtocol: AnyObject {
    func setupView(title: String,
                   filteredPLPView: UIView)
    func updateTitle(title: String, itemsCount: Int)
}
