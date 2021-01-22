//
//  ViewController.swift
//  TenserFlow Demo
//
//  Created by Paras Rastogi on 23/12/20.
//
import UIKit
import Bond
import Alamofire
import TagListView
import ReactiveKit

class TabViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var tabBarCollectionView: UICollectionView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var pickedImage: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var msgPlaceHolderLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var imageTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstraintFromSuperView: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstraintFromImage: NSLayoutConstraint!
    
    let viewModel = TabViewViewModel()
    var rectViewArr : [RectangleView] = []
    var result : Result?
    var allResponse: AllResponse?
    var isDataLoaded = false
    var tableHeightObserver: NSObjectProtocol?
    var classificationViewModel = ClassificationViewModel()
    var objectDetectionViewModel = ObjectDetectionViewModel()
    var imageQualityViewModel = ImageQualityViewModel()
    var changeSliderValueOnTagTapHandler : ((Float) -> Void)?
    var currentDeviceType: UIUserInterfaceIdiom?
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        initialSetUp()
        tableHeightObserver = tableView.observe(\.contentSize, options: [.new], changeHandler: {[weak self] (tableView, _) in
            tableView.layer.removeAllAnimations()
            self?.tableHeightConstraint.constant = tableView.contentSize.height
        })
    }
    
    
    fileprivate func updateConstraints() {
        switch UIDevice.current.userInterfaceIdiom{
        case .pad:
            
            if UIApplication.shared.statusBarOrientation.isLandscape {
                print("landscape")
            } else {
                print("portrait")
            }
           
            if view.bounds.width < view.bounds.height{
                NSLayoutConstraint.deactivate([tableViewWidthConstraint,imageWidthConstraints,tableViewTopConstraintFromSuperView])
                
                NSLayoutConstraint.activate([tableViewLeadingConstraint,imageTrailingConstraint,tableViewTopConstraintFromImage])
            }else{
                NSLayoutConstraint.deactivate([tableViewLeadingConstraint,imageTrailingConstraint,tableViewTopConstraintFromImage])
                NSLayoutConstraint.activate([tableViewWidthConstraint,imageWidthConstraints,tableViewTopConstraintFromSuperView])
            }

            print("Constant -- \(tableViewTopConstraintFromSuperView.constant)")
            view.layoutIfNeeded()
            if let image = pickedImage.image{
                imageHeightConstraint.constant = pickedImage.bounds.width * (image.size.height / image.size.width)
            print("pickedimage boud \(pickedImage.bounds.width)")
            }

        default:
            currentDeviceType = .unspecified
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateConstraints()
  
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateConstraints()
        if UIDevice.current.orientation.isLandscape {
            print("landscape")
        } else {
            print("portrait")
        }
    }


    func showHideViewOnSlide(_ decimalVal: Float){
        for rect in rectViewArr{
            if rect.prob >= decimalVal{
                rect.layer.borderWidth = 2
                rect.label.isHidden = false
            }else{
                rect.layer.borderWidth = 0
                rect.label.isHidden = true
            }
        }
    }
    
    func toggleRectangles(_ index: Int){
       let rectView = rectViewArr[index]
       let borderWidth = rectView.layer.borderWidth
        rectView.label.isHidden = (borderWidth == 0) ? false : true
       rectViewArr[index].layer.borderWidth = (borderWidth == 0) ? 2 : 0
        if let changeSliderValueOnTagTapHandler = changeSliderValueOnTagTapHandler{
            changeSliderValueOnTagTapHandler(rectView.prob)
        }
    }
    
    func hideAllViews(){
        tableView.isHidden = true
    }
    
//    func addChildViewControllers(){
//        let  classificationVC = ClassificationViewController()
//        classificationVC.classificationViewModel = ClassificationViewModel()
//        addChildViewController(viewController: classificationVC, containerView: self.replacableView)
//        self.classificationVC = classificationVC
//
//        let objectDetectionVC = ObjectDetectionViewController()
//        objectDetectionVC.objectDetectionViewModel = ObjectDetectionViewModel()
//        addChildViewController(viewController: objectDetectionVC, containerView: self.replacableView)
//        self.objectDetectionVC = objectDetectionVC
//
//        let imageQualityVC = ImageQualityViewController()
//        imageQualityVC.imageQualityViewModel = ImageQualityViewModel()
//        addChildViewController(viewController: imageQualityVC, containerView: self.replacableView)
//        self.imageQualityVC = imageQualityVC
//    }
    
    func registerCells() {
        tabBarCollectionView.register(TabBarCollectionViewCell.nib, forCellWithReuseIdentifier: TabBarCollectionViewCell.identifier)
    }
    
    fileprivate func bindViewModel() {
        viewModel.tabButtons.bind(to: tabBarCollectionView) { [weak self]( array, indexPath, collectionView) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarCollectionViewCell.identifier , for: indexPath) as! TabBarCollectionViewCell
            debugPrint(array)
            let tab = array[indexPath.item]
            cell.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            cell.titleLabel.text = tab.title
            cell.setSelected(status: self?.viewModel.selectedTab.value == Tabs.init(rawValue: indexPath.item))
            return cell
        }.dispose(in: bag)
        
        tabBarCollectionView.reactive.selectedItemIndexPath.observeNext {[weak self] (indexPath) in
            self?.viewModel.selectedTab.value = Tabs.init(rawValue: indexPath.item) ?? .classification
            self?.tabBarCollectionView?.reloadData()
        }.dispose(in: bag)
        
        takePhotoButton.reactive.tap.observeNext {[weak self] in
            self?.addPhotosAction()
        }.dispose(in: bag)
        
        viewModel.selectedTab.bind(to: self) { (vc, tab) in
            vc.viewModel.tabSelected()
        }.dispose(in: bag)
        
        viewModel.list.bind(to: tableView) {[unowned self] (list, indexPath, tableView) -> UITableViewCell in
            let item =  list[indexPath.row]
            switch item {
            case .classification:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ClassificationCell") as! ClassificationTableViewCell
                cell.setData(self.classificationViewModel)
                hideRectViews(isHidden: true, rectViewArr: rectViewArr)
                return cell
            case .imageQuality:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageQualityCell") as! ImageQualityTableViewCell
                cell.setData(self.imageQualityViewModel)
                hideRectViews(isHidden: true, rectViewArr: rectViewArr)
                return cell
            case .objectDetection:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ObjectDetectionCell") as! ObjectDetectionTableViewCell
                cell.setData(self.objectDetectionViewModel , viewController: self)
                cell.onTagTapHandler = {[weak self] index in
                    self?.toggleRectangles(index)
                }
                cell.sliderChangedHandler = {[weak self] decimalVal in
                    self?.showHideViewOnSlide(decimalVal)
                }
                hideRectViews(isHidden: false, rectViewArr: rectViewArr)
                return cell
            }
        }.dispose(in: bag)
    }
    
    func initialSetUp(){
      
        let main_string = "Tap on \"Take Picture\" to upload a Picture."
        let string_to_color = "Take Picture"
        let attributedString = NSMutableAttributedString(string:main_string)
        let range = (main_string as NSString).range(of: string_to_color)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(rgb: 0x3274DC) , range: range)
        msgPlaceHolderLabel.attributedText = attributedString
        bindViewModel()

    }
    
    private func addPhotosAction() {
        let alertController = UIAlertController(title: "Choose from", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: AppMessages.Alert.cancel, style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: AppMessages.Alert.openCamera, style: .default, handler: { (_) in
            UtilityManager.checkCameraPermission(with: AppMessages.Alert.cameraPermissionMessage, inViewcontroller: self, completionHandler: {[weak self] in
                self?.openCamera()
            })
        }))
        alertController.addAction(UIAlertAction(title: AppMessages.Alert.openGallery, style: .default, handler: { (_) in
            UtilityManager.checkPhotoLibraryPermission(with: AppMessages.Alert.photosLibraryPermissionMessage, inViewcontroller: self, completionHandler: {
                [weak self] in
                self?.openCustomGallery()
            })
        }))
        alertController.popoverPresentationController?.sourceView = takePhotoButton
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showCurrentView(tab: Tabs){
        tableView.isHidden = false
    }
    
    func hideRectViews(isHidden: Bool, rectViewArr: [RectangleView]){
        for view in rectViewArr{
            view.isHidden = isHidden
        }
    }
    
    @objc fileprivate func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            UtilityManager.showAlert(title: nil, message: AppMessages.Alert.cameraUnavailable, controller: self)
        }
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        // print out the image size as a test
        print(image.size)
        pickedImage.image = image
        imageHeightConstraint.constant = pickedImage.bounds.width * (image.size.height / image.size.width)
        picker.dismiss(animated: true, completion: nil)
        rectViewArr.removeAll()
        msgPlaceHolderLabel.isHidden = true
        overlayView.subviews.map({ $0.removeFromSuperview() })
        hideAllViews()
        uploadImage(image: image)
    }
    
    func uploadImage(image: UIImage){
        viewModel.uploadImage(image: image) {[weak self] (allresponse) in
            self?.handleResonse(allResponse: allresponse)
        }
    }
    
    func handleResonse(allResponse: AllResponse){
        if allResponse.status == 1{
            isDataLoaded = true
            self.allResponse = allResponse
            result = allResponse.result
            classificationViewModel.refreshData(allResponse: allResponse)
            imageQualityViewModel.refreshData(allResponse: allResponse)
            objectDetectionViewModel.refreshData(allResponse: allResponse)
            viewModel.dataLoaded = true
            viewModel.tabSelected()
            _ = allResponse.result?.objectDetection.objects.map { drawRectangle(xmin: $0.xmin, xmax: $0.xmax, ymin: $0.ymin, ymax: $0.ymax , objTitle: $0.mainLabel, prob: CGFloat($0.prob))  }
            showCurrentView(tab: viewModel.selectedTab.value)
        }else{
            showErrorMsg(allResponse)
        }
    }
    
    func showErrorMsg(_ allResponse: AllResponse){
        msgPlaceHolderLabel.text = allResponse.error?.errorMsg
    }
    
    fileprivate func openCustomGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            if let parent = self.parent?.parent {
                parent.present(myPickerController, animated: false, completion: nil)
            } else {
                self.present(myPickerController, animated: false, completion: nil)
            }
        }
    }
    
    func drawRectangle(xmin: Int , xmax: Int, ymin: Int, ymax: Int, objTitle: String, prob: CGFloat){
        // get screen size object.
        let screenSize: CGRect = UIScreen.main.bounds
        let imageSize = pickedImage.image?.size ?? .zero
        let imageViewSize = pickedImage.bounds.size
        
        let widthRatio = imageViewSize.width / imageSize.width
        let heightRatio = imageViewSize.height / imageSize.height
        
        // the rectangle top left point x axis position.
        let xPos = CGFloat(xmin) * widthRatio
        
        // the rectangle top left point y axis position.
        let yPos = CGFloat(ymin) * heightRatio
        
        // the rectangle width.
        let rectWidth = xmax - xmin
        
        // the rectangle height.
        let rectHeight = ymax - ymin
        
        // Create a CGRect object which is used to render a rectangle.
        let rectFrame: CGRect = CGRect(x:CGFloat(xPos), y:CGFloat(yPos), width:CGFloat(rectWidth) * widthRatio  , height:CGFloat(rectHeight) * heightRatio)
        
        // Create a UIView object which use above CGRect object.
        let rectangleView = RectangleView(name: objTitle, prob: Float(prob), frame: rectFrame)
        rectangleView.layer.borderWidth = 2
        //rectangleView.layer.borderColor = UIColor.red.cgColor
        // Add above UIView object as the main view's subview.
        rectViewArr.append(rectangleView)
        self.overlayView.addSubview(rectangleView)
    }
    
    
}



