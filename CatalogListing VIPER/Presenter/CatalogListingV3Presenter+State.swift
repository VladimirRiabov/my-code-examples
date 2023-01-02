//
//  CatalogListingV3Presenter+State.swift
//  MOBAPP_B2C
//
//  Created by Рябов Владимир Васильевич on 23.02.2022.
//

import Foundation

extension CatalogListingV3Presenter {
    // sourcery: AutoLenses
    struct State {
        let catalogGroupId: String
        let catalogGroupName: String
        
        let loadedItemsCount: Int
        
        let listingInfo: ProductListingInfo
        
        static func initial() -> Self {
            State(catalogGroupId: "",
                  catalogGroupName: "",
                  loadedItemsCount: 0,
                  listingInfo: ProductListingInfo(title: "",
                                                  promoInfo: nil,
                                                  strategyId: nil,
                                                  outgoingSource: .mvideo))
        }
    }
}
