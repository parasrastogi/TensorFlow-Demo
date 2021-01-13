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

class TabViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var tabBarCollectionView: UICollectionView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var replacableView: UIView!
    @IBOutlet weak var pickedImage: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    weak var classificationVC: ClassificationViewController!
    weak var imageQualityVC: ImageQualityViewController!
    weak var objectDetectionVC: ObjectDetectionViewController!
    let viewModel = TabViewViewModel()
    var rectViewArr : [RectangleView] = []
    // @IBOutlet weak var textLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        addChildViewControllers()
        initialSetUp()
        hideAllViews()
        objectDetectionVC.onTagTapHandler = {[weak self] index in
            self?.toggleRectangles(index)
        }
    }
    
    
    func toggleRectangles(_ index: Int){
       let rectView = rectViewArr[index]
       let borderWidth = rectView.layer.borderWidth
        rectView.label.isHidden = (borderWidth == 0) ? false : true
       rectViewArr[index].layer.borderWidth = (borderWidth == 0) ? 2 : 0
    }
    
    func hideAllViews(){
        classificationVC.view.isHidden = true
        imageQualityVC.view.isHidden = true
        objectDetectionVC.view.isHidden = true
    }
    
    func addChildViewControllers(){
        let  classificationVC = ClassificationViewController()
        classificationVC.classificationViewModel = ClassificationViewModel()
        addChildViewController(viewController: classificationVC, containerView: self.replacableView)
        self.classificationVC = classificationVC
        
        let objectDetectionVC = ObjectDetectionViewController()
        objectDetectionVC.objectDetectionViewModel = ObjectDetectionViewModel()
        addChildViewController(viewController: objectDetectionVC, containerView: self.replacableView)
        self.objectDetectionVC = objectDetectionVC
        
        let imageQualityVC = ImageQualityViewController()
        imageQualityVC.imageQualityViewModel = ImageQualityViewModel()
        addChildViewController(viewController: imageQualityVC, containerView: self.replacableView)
        self.imageQualityVC = imageQualityVC
    }
    
    func registerCells() {
        tabBarCollectionView.register(TabBarCollectionViewCell.nib, forCellWithReuseIdentifier: TabBarCollectionViewCell.identifier)
    }
    
    func initialSetUp(){
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
            vc.showCurrentView(tab: tab)
        }.dispose(in: bag)
        
        //        viewModel.selectedTab.observeNext { (tab) in  // use bind setter
        //            switch tab{
        //            case .classification:
        //                debugPrint("classification")
        //                self.imageQualityVC.view.isHidden = true
        //            case .imageQuality:
        //                debugPrint("obj quality")
        //            case .objectDetection:
        //
        //                debugPrint("obj det")
        //            }
        //        }.dispose(in: bag)
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
        switch tab{
        case .classification:
            debugPrint("classification")
            self.imageQualityVC.view.isHidden = true
            self.classificationVC.view.isHidden = false
            self.objectDetectionVC.view.isHidden = true
            hideRectViews(isHidden: true)
        case .imageQuality:
            self.imageQualityVC.view.isHidden = false
            self.classificationVC.view.isHidden = true
            self.objectDetectionVC.view.isHidden = true
            hideRectViews(isHidden: true)
            debugPrint("obj quality")
        case .objectDetection:
            self.imageQualityVC.view.isHidden = true
            self.classificationVC.view.isHidden = true
            self.objectDetectionVC.view.isHidden = false
            hideRectViews(isHidden: false)
            debugPrint("obj det")
        }
    }
    
    func hideRectViews(isHidden: Bool){
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
        uploadImage(image: image)
    }
    
    func uploadImage(image: UIImage){
        if let compressedImageData = image.jpeg(.medium) {
            hideAllViews()
            UtilityManager.showProgress(status: "Uploading photo...")
            print(compressedImageData.count)
            let compressedJPGImage = UIImage(data: compressedImageData)
            let imageData = ["content": viewModel.getBase64(image: compressedJPGImage!)]
            let request : [String: Any] = ["request_type": "AL", "input_type":"BASE64", "API_KEY":"GDWJC8P38YQL3S2","image": imageData ]
            let requestParam = ["request" : request]
            
            Alamofire.request("https://api.inscene.ai/annotate?v=1.3", method: .post, parameters: requestParam, encoding: JSONEncoding.default)
                .responseJSON {[weak self] response in
                    UtilityManager.hideProgress()
                    switch response.result{
                    case .success(let res):
                        if let res = res as? [String : Any]{
                            do {
                                print(res)
                                let  responseData = try DataCoder.decode(AllResponse.self, from: res)
                                self?.handleResonse(allResponse: responseData)
                                //
                                debugPrint(responseData)
                            } catch {
                                print(error)
                            }
                        }
                        
                    case .failure(_):
                        debugPrint("jerror response")
                        
                    }
                }
        }else{
            debugPrint("Image compression failed.")
        }
    }
    
    func handleResonse(allResponse: AllResponse){
        //showCurrentView(tab: viewModel.selectedTab.value)
        classificationVC.classificationViewModel.refreshData(allResponse: allResponse)
        imageQualityVC.imageQualityViewModel.refreshData(allResponse: allResponse)
        objectDetectionVC.objectDetectionViewModel.refreshData(allResponse: allResponse)
        
        _ = allResponse.result.objectDetection.objects.map { drawRectangle(xmin: $0.xmin, xmax: $0.xmax, ymin: $0.ymin, ymax: $0.ymax , objTitle: $0.mainLabel)  }
        showCurrentView(tab: viewModel.selectedTab.value)
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
    
    func drawRectangle(xmin: Int , xmax: Int, ymin: Int, ymax: Int, objTitle: String){
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
        let rectangleView = RectangleView(name: objTitle, frame: rectFrame)
        rectangleView.layer.borderWidth = 2
        //rectangleView.layer.borderColor = UIColor.red.cgColor
        // Add above UIView object as the main view's subview.
        rectViewArr.append(rectangleView)
        self.overlayView.addSubview(rectangleView)
    }
    
    
    
    fileprivate func onSelection(indexPath: IndexPath) {
        viewModel.tabSelectedIndexPath = indexPath
        //tabsCollectionView?.reloadData()
        
        //        switch tabButtons[viewModel.tabSelectedIndexPath.row] {
        //        case .overview:
        //            overViewTextArea.attributedText = overViewTextArea.attributtedString(text: viewModel.overview, more: false)
        //            overviewStackViewHeight.constant = 60
        //            logEvent(eventCode: .nhnMyComOvw)
        //
        //        case .amenities:
        //            overViewTextArea.attributedText = attributtedString(text: viewModel.amenityTextArea)
        //            logEvent(eventCode: .nhnAmn)
        //            overviewStackViewHeight.constant = 0
        //
        //        case .school:
        //            overViewTextArea.attributedText = attributtedString(text: viewModel.schoolTextArea)
        //            overviewStackViewHeight.constant = 0
        //
        //        case .utilities:
        //            overViewTextArea.attributedText = attributtedString(text: viewModel.utilityTextArea)
        //            overviewStackViewHeight.constant = 0
        //        }
        //        adjustAddressView()
    }
    
}



