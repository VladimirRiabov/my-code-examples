//
//  CatalogListingV3ViewOutputProtocol.swift
//  MOBAPP_B2C
//
//  Created by Рябов Владимир Васильевич on 21.02.2022.
//

import Foundation

protocol CatalogListingV3ViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()

    func didTapOnSearch()
}
