//
//  ViewController.swift
//  CryptoRxSwift
//
//  Created by Yavuz Ulgar on 18.06.2023.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    let disposeBag = DisposeBag()
    let cryptoVM = CryptoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        setupBindings()
        cryptoVM.requestData()
    }
    
    private func setupBindings() {
        cryptoVM.loading
            .bind(to: self.indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        cryptoVM
            .error
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { failure in
                print(failure)
            })
            .disposed(by: disposeBag)

        cryptoVM.cryptos
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: tableView.rx.items(cellIdentifier: "cryptoTableViewCellID", cellType: CryptoTableViewCell.self)) { (row,item,cell) in
            cell.item = item
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Crypto.self).subscribe(onNext: { item in
            print("SelectedItem: \(item.currency)")
            }).disposed(by: disposeBag)
    }
}
