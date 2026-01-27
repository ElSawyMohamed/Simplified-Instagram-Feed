//
//  Observable.swift
//  CodeBase
//
//  Created by MohamedSawy on 4/7/24.
//

import RxSwift
import RxCocoa
import UIKit

final class BindableObservable<Value> {
    
    private let subject: BehaviorSubject<Value>
    private let disposeBag = DisposeBag()
    
    var value: Value {
        get {
            return try! subject.value()
        }
        set {
            subject.onNext(newValue)
        }
    }
    
    init(_ value: Value) {
        subject = BehaviorSubject(value: value)
    }
    
    func observe(onNext: @escaping (Value) -> Void) {
        subject.subscribe(onNext: onNext)
            .disposed(by: disposeBag)
    }
    
    func asObservable() -> Observable<Value> {
        return subject.asObservable()
    }
 
    // Method to bind to UITableView
    func bind<TableView: UITableView, Cell: UITableViewCell>(
        to tableView: TableView,
        cellIdentifier: String,
        delegate: UITableViewDelegate,
        configureCell: @escaping (Int, Value.Element, Cell) -> Void
    ) where Value: Collection {
        asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: Cell.self)) { index, element, cell in
                configureCell(index, element, cell)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(delegate).disposed(by: disposeBag)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }
    
    // Method to handle item deselection for UITableView
    func handleSelectionTableView<TableView: UITableView>(
        in tableView: TableView,
        itemSelected: @escaping (Int) -> Void
    ) {
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                itemSelected(indexPath.row)
            })
            .disposed(by: disposeBag)
    }
    
    // Method to handle item deselection for UITableView
    func handleDeselectionTableView<TableView: UITableView>(
        in tableView: TableView,
        itemDeselected: @escaping (Int) -> Void
    ) {
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                itemDeselected(indexPath.row)
            })
            .disposed(by: disposeBag)
    }
    
    func bindContentSizeToHeightConstraint<tableView: UITableView>(
        of tableView: tableView,
        heightConstraint: NSLayoutConstraint
    ) {
        tableView.rx.observe(CGSize.self, "contentSize")
            .compactMap { $0?.height }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance) // Ensure events are handled asynchronously
            .subscribe(onNext: { height in
                heightConstraint.constant = height
                UIView.animate(withDuration: 0.3) {
                    tableView.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }

    // Method to bind to UICollectionView
    func bind<CollectionView: UICollectionView, Cell: UICollectionViewCell>(
        to collectionView: CollectionView,
        cellIdentifier: String,
        delegate: UICollectionViewDelegate,
        configureCell: @escaping (Int, Value.Element, Cell) -> Void
    ) where Value: Collection {
        asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: cellIdentifier, cellType: Cell.self)) { index, element, cell in
                configureCell(index, element, cell)
            }
            .disposed(by: disposeBag)
                
        collectionView.rx.setDelegate(delegate).disposed(by: disposeBag)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    // Method to handle item deselection for UICollectionView
    func handleSelectionCollectionView<CollectionView: UICollectionView>(
        in collectionView: CollectionView,
        itemSelected: @escaping (Int) -> Void
    ) {
        collectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                itemSelected(indexPath.row)
            })
            .disposed(by: disposeBag)
    }
    
    // Method to handle item deselection for UICollectionView
    func handleDeselectionCollectionView<CollectionView: UICollectionView>(
        in collectionView: CollectionView,
        itemDeselected: @escaping (Int) -> Void
    ) {
        collectionView.rx.itemDeselected
            .subscribe(onNext: { indexPath in
                itemDeselected(indexPath.row)
            })
            .disposed(by: disposeBag)
    }
    
    // Method to bind the collection view's content size to its height constraint
    func bindContentSizeToHeightConstraint<CollectionView: UICollectionView>(
        of collectionView: CollectionView,
        heightConstraint: NSLayoutConstraint
    ) {
        collectionView.rx.observe(CGSize.self, "contentSize")
            .compactMap { $0?.height }
            .distinctUntilChanged()
            .subscribe(onNext: { height in
                heightConstraint.constant = height
                UIView.animate(withDuration: 0.3) {
                    collectionView.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: NSLayoutConstraint {
    /// Bindable sink for `constant` property.
    public var constant: Binder<CGFloat> {
        return Binder(self.base) { constraint, constant in
            constraint.constant = constant
            UIView.animate(withDuration: 0.3) {
                constraint.firstItem?.superview??.layoutIfNeeded()
            }
        }
    }
}
