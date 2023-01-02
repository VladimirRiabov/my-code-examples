//
//  CatalogListingV3Presenter.swift
//  MOBAPP_B2C
//
//  Created by Рябов Владимир Васильевич on 21.02.2022.
//

import Foundation

final class CatalogListingV3Presenter: BasePresenter {

    private weak var output: CatalogListingModuleOutputProtocol?
    
    private weak var view: CatalogListingV3ViewInputProtocol?
    private let interactor: CatalogListingV3InteractorInputProtocol
    private let router: CatalogListingV3RouterInputProtocol
    
    private let filteredPLPInput: FilteredPLPModuleInputProtocol
    
    private var catalogGroupName = ""

    init(view: CatalogListingV3ViewInputProtocol,
         interactor: CatalogListingV3InteractorInputProtocol,
         router: CatalogListingV3RouterInputProtocol,
         filteredPLPInput: FilteredPLPModuleInputProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.filteredPLPInput = filteredPLPInput
        
        super.init(interactor: interactor as? BaseInteractor,
                   router: router as? BaseRouter,
                   viewController: view as? BaseViewController)
    }
}

// MARK: - CatalogListingV3ModuleInputProtocol
extension CatalogListingV3Presenter: CatalogListingModuleInputProtocol {
    func configureModule(group: GroupV2,
                         intermediateGroup: GroupV2?,
                         rootGroup: GroupV2,
                         isFromDeeplink: Bool,
                         output: CatalogListingModuleOutputProtocol?) {
        self.output = output
        
        catalogGroupName = group.name
        
        filteredPLPInput.configureModule(groupId: group.mCatalogId,
                                         groupFilters: group.filters,
                                         listingTitle: group.name,
                                         promoInfo: nil,
                                         shouldSpecifyCategory: false,
                                         isFromDeeplink: isFromDeeplink,
                                         output: self)
    }
}

// MARK: - CatalogListingV3ViewOutputProtocol
extension CatalogListingV3Presenter: CatalogListingV3ViewOutputProtocol {
    func viewDidLoad() {
        view?.setupView(title: catalogGroupName,
                        filteredPLPView: filteredPLPInput.viewController().view)
    }
    
    func viewWillAppear() {
        interactor.sendUXFeedbackEvent(.listingView60s)
    }
    
    func viewWillDisappear() {
        interactor.cancelUXFeedbackEvent(.listingView60s)
    }
    
    func didTapOnSearch() {
        router.showSearch()
    }
}

// MARK: - CatalogListingV3InteractorOutputProtocol
extension CatalogListingV3Presenter: CatalogListingV3InteractorOutputProtocol {
}

// MARK: - FilteredPLPModuleOutputProtocol
extension CatalogListingV3Presenter: FilteredPLPModuleOutputProtocol {
    func filteredPLPDidTapToCatalog() {
        output?.didFinishMaterialListingModulePopToRoot()
    }
    
    func filteredPLPDidFetchDetails(forPage page: Int, totalCount: Int) {
        interactor.triggerEventViewListingResults(totalCount: totalCount,
                                                  currentPage: page)
    }
    
    func filteredPLPDidUpdateItems(totalCount: Int) {
        view?.updateTitle(title: catalogGroupName,
                          itemsCount: totalCount)
    }
    
    func filteredPLPDidChangeContentSize(_ contentSize: CGSize,
                                         contentInsetTop: CGFloat,
                                         contentInsetBottom: CGFloat) { }
}

// MARK: - private
extension CatalogListingV3Presenter {
}
