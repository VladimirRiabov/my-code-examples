//
//  CatalogListingV3ViewController.swift
//  MOBAPP_B2C
//
//  Created by Рябов Владимир Васильевич on 21.02.2022.
//

import UIKit
import MVUIKit

final class CatalogListingV3ViewController: BaseViewController {

    weak var output: CatalogListingV3ViewOutputProtocol? {
        didSet {
            basePresenter = output as? BasePresenter
        }
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        output?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output?.viewWillDisappear()
    }
}

// MARK: - CatalogListingV3ViewInputProtocol
extension CatalogListingV3ViewController: CatalogListingV3ViewInputProtocol {

    func setupView(title: String,
                   filteredPLPView: UIView) {
        extendedLayoutIncludesOpaqueBars = true
        
        configureNavigationBar(title: title)
        
        filteredPLPView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filteredPLPView)

        NSLayoutConstraint.activate(
            filteredPLPView.mv.constraintsToSuperviewEdges()
        )
    }
    
    func updateTitle(title: String, itemsCount: Int) {
        setTwoLinesCustomTitle(firstLineTitle: title,
                               secondLine: String.shortStringHeaderFrom(count: itemsCount))
    }
}

// MARK: - Private
extension CatalogListingV3ViewController {
    private func configureNavigationBar(title: String) {
        setCustomTitle(title)
        navigationController?.setBackButton()
        
        navigationController?.setNavigationBarWith(
            [.search],
            target: { [weak self] item in
                self?.output?.didTapOnSearch()
            }
        )
    }
}
