//
//  CatalogListingV3InteractorInputProtocol.swift
//  MOBAPP_B2C
//
//  Created by Рябов Владимир Васильевич on 21.02.2022.
//

import Foundation

// sourcery: AutoMockable
protocol CatalogListingV3InteractorInputProtocol: AutoTrackingScreenViewInteractorProtocol,
                                                  UXFeedbackDelaySendable {
    func triggerEventViewListingResults(totalCount: Int, currentPage: Int)
}
