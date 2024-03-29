//
//  SettingsViewController.swift
//  RS
//
//  Created by ICoon on 28.06.2022.
//

import UIKit

public final class SettingsViewController: UIViewController {
    
    
    
    private var soundUtil: SoundUtil? = nil
    
    private let dataSource = SettingsDataSourse()
    
    private let presenter: SettingsPresenter
    
    @IBOutlet weak var tableView: UITableView!
    
 
    
    
    
    @available(iOS, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(presenter: SettingsPresenter) {
        self.presenter = presenter
        
        super.init(nibName: "SettingsViewController", bundle: Bundle.main)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
        self.tableView.tableFooterView = UIView()

       
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.presenter.fetchFreshData()
    }
    
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            self.presenter.savePreferences()
            self.reLoadNavigationSound()
        }
    }
    
    func navigateToDebug(){
        let navigator = getAppComponent().getNavigator()
        let destination = navigator.getDebugScreen()
        navigator.navigate(start: self, destination: destination)
    }
    
    func navigateToCreate(){
        let navigator = getAppComponent().getNavigator()
        let storage = getAppComponent().getStorage()
        let alertUtil = getAppComponent().getAlertUtil()
        let fileUtil = getAppComponent().getFileUtil()
        let destination = navigator.getCreateScreen(
            storage: storage,
            fileUtil: fileUtil,
            alertUtil: alertUtil)
        
        navigator.navigate(start: self, destination: destination)
    }
    
    func navigateToImport(){
        let navigator = getAppComponent().getNavigator()
        let alertUtil = getAppComponent().getAlertUtil()
        let openFileUtil = getAppComponent().getOpenFileUtil()
        let importUtil = getAppComponent().getImportUtil()
        let destination = navigator.getOpenFileScreen(
            openFileUtil: openFileUtil,
            alertUtil: alertUtil,
            importUtil: importUtil)
        navigator.navigate(start: self, destination: destination)
    }
    
    func navigateToColorSelection(){
        presenter.savePreferences()
        
        let storage = getAppComponent().getStorage()
        let navigator = getAppComponent().getNavigator()
        let destination = navigator.getSelectColorScreen(storage: storage)
        navigator.navigate(start: self, destination: destination)
    }
    
    func startSelectColorAlert(title: String, currentColor: Color, callback: @escaping (_ newColor: Color) -> Void){
        let model = UISelectionDialogModel(
            callback: callback,
            title: title,
            curentColor:  currentColor)
        
        let navigator = getAppComponent().getNavigator()
        let destination = navigator.getSelectColorAlert(model: model)
        navigator.navigateAlert(start: self, destination: destination)
    }
    
    func reloadData(models: [SettingsModel]){
        self.dataSource.setData(data: models)
        self.tableView.reloadData()
    }
    
    func registerCells(models: [SettingsModel]){
        
        models.forEach{
            let nib = UINib(nibName: $0.reuseIdentifier, bundle: nil)
            self.tableView?.register(nib, forCellReuseIdentifier: $0.reuseIdentifier)
        }
        
        self.dataSource.setData(data: models)
        self.tableView.reloadData()
    }
    
    func didColorSelectorTap(){
        self.soundUtil = getAppComponent().getSoundUtil(sound: SoundCaf.sectionSound())
        self.soundUtil?.play()
    }
    
    func didSwichChanged() {
        self.soundUtil = getAppComponent().getSoundUtil(sound: SoundCaf.actionSound())
        self.soundUtil?.play()
    }
    
}
