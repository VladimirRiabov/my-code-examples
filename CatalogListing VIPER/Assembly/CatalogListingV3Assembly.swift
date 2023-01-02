//
//  CatalogListingV3Assembly.swift
//  MOBAPP_B2C
//
//  Created by Рябов Владимир Васильевич on 21.02.2022.
//

import UIKit

final class CatalogListingV3Assembly: BaseAssembly {
    
    func makeModule() -> AssembledScreen<CatalogListingModuleInputProtocol> {
        let managerFactory = ManagerFactory.shared
        let analyticsFactory = AnalyticsFactory.shared
        
        let interactor = CatalogListingV3Interactor
            .init(sendAnalyticsEventManager: analyticsFactory.makeSendAnalyticsEventManager(),
                  sendUXFeedbackCampaignEventManager: managerFactory.makeSendUXFeedbackCampaignEventManager())
        injectCommonDependencies(intoInteractor: interactor)
        
        let viewController = CatalogListingV3ViewController()
        let router = CatalogListingV3Router(viewController: viewController)
        
        let filteredPLP = FilteredPLPAssembly().makeModule()
        viewController.addChild(filteredPLP.viewController)
        filteredPLP.viewController.didMove(toParent: viewController)
        
        let presenter = CatalogListingV3Presenter(view: viewController,
                                                  interactor: interactor,
                                                  router: router,
                                                  filteredPLPInput: filteredPLP.input)
        interactor.output = presenter
        viewController.output = presenter
        
        return AssembledScreen(input: presenter,
                               viewController: viewController)
    }
}
