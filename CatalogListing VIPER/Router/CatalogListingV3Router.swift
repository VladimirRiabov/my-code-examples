//
//  CatalogListingV3Router.swift
//  MOBAPP_B2C
//
//  Created by Рябов Владимир Васильевич on 21.02.2022.
//

import Foundation

final class CatalogListingV3Router: BaseRouter, ShowingPDPRouter {
    weak var output: CatalogListingV3RouterOutputProtocol?
    
    // >>>
    // TODO: Routing: добавлено временно
    private var persPriceFlowCoordinator: PersPriceFlowCoordinatorProtocol?
    private var shelvesFlowCoordinator: ShelvesFlowCoordinatorProtocol?
    var pdpFlowCoordinator: PDPFlowCoordinatorProtocol?
    // <<<
}

// MARK: - CatalogListingV3RouterInputProtocol
extension CatalogListingV3Router: CatalogListingV3RouterInputProtocol {
    func showSearch() {
        guard let viewController = viewController else { return }
        let searchListing = SearchListingAssembly().makeModule()
        searchListing.0
            .input
            .configureModule(searchPlaceholder: L10n.Localizable.itemName,
                             promoId: nil,
                             output: nil)
        searchListing.1
            .showNavigationVCWithHeroAnimate(from: viewController,
                                             embedInNavController: false,
                                             presenting: .fade,
                                             dismissing: .fade)
    }
}
