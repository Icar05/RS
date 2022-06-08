//
//  MenuViewController.swift
//  HobbyRandomizer
//
//  Created by ICoon on 07.06.2022.
//

import UIKit

public final class MenuViewController: UIViewController {
    
    
    private let dataSource = MenuDataSource()
    
    private let presenter: MenuPresenter
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    @available(iOS, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(presener: MenuPresenter) {
        self.presenter = presener
        
        super.init(nibName: "MenuViewController", bundle: Bundle.main)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        
        setupUI()
    }
    
    func didDataUpdate(data: [MenuCellModel]){
        self.dataSource.setDataSource(dataSource: data)
        self.collectionView.reloadData()
    }
    
    private func setupUI(){
        let identifier = self.dataSource.getIdentifier()
        let nib = UINib(nibName: identifier, bundle: nil)
        
        self.collectionView?.register(nib, forCellWithReuseIdentifier: identifier)
        self.collectionView.dataSource = dataSource
        self.collectionView.delegate = dataSource
        self.dataSource.setDelegate(delegate: self)
    }
}

extension MenuViewController: MenuDelegate{
    
    func onItemSelected(item: ScreenTypes) {
        
        let navigator =  (UIApplication.shared.delegate as! AppDelegate).getNavigator()
        guard let destination = getController(item: item, navigator: navigator) else {
            print("not implemented: \(item)")
            return
        }

        navigator.navigate(start: self, destination: destination)
    }
    
    
    func getController(item: ScreenTypes, navigator: Navigator) -> UIViewController?{
        if(item == .Casino){
            return navigator.getCasinoScreen()
        }
        
        return nil
    }
}