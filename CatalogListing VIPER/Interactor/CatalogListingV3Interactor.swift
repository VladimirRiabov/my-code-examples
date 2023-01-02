//
//  CatalogListingV3Interactor.swift
//  MOBAPP_B2C
//
//  Created by Рябов Владимир Васильевич on 21.02.2022.
//

import Foundation

final class CatalogListingV3Interactor: BaseInteractor {
    override var screenName: String { .ScreenName.plpCategory }
    override var screenType: String { .ScreenType.plp }
    
    weak var output: CatalogListingV3InteractorOutputProtocol? {
        didSet {
            basePresenter = output as? BasePresenter
        }
    }

    private let sendAnalyticsEventManager: SendAnalyticsEventManagerProtocol
    var sendUXFeedbackCampaignEventManager: SendUXFeedbackCampaignEventManagerProtocol
    
    var uxFeedbackEventToCancellable: [UXFeedbackCampaignEvent : Cancellable] = [:]
    
    init(sendAnalyticsEventManager: SendAnalyticsEventManagerProtocol,
         sendUXFeedbackCampaignEventManager: SendUXFeedbackCampaignEventManagerProtocol) {
        self.sendAnalyticsEventManager = sendAnalyticsEventManager
        self.sendUXFeedbackCampaignEventManager = sendUXFeedbackCampaignEventManager
    }
}

// MARK: - CatalogListingV3InteractorInputProtocol
extension CatalogListingV3Interactor: CatalogListingV3InteractorInputProtocol {
    func triggerEventViewListingResults(totalCount: Int, currentPage: Int) {
        sendAnalyticsEventManager.execute(.viewListingResults(totalItemsCount: totalCount,
                                                              currentPage: currentPage))
    }
}
