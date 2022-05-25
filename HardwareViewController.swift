import UIKit
import CloudKit
import MobileCoreServices
import CoreData

class HardwareViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UIScrollViewDelegate{
    //MARK: Properties
    @IBOutlet weak var hardwareDetails: UITextField!
    @IBOutlet weak var selfWeight: UITextField!
    @IBOutlet weak var manufWeight: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var hardwareNotes: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var photoScrollView: UIScrollView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lengthView: UIView!
    @IBOutlet weak var length: UITextField!
    @IBOutlet weak var density: UITextField!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var lengthUnitLabel: UILabel!
    @IBOutlet weak var densityLabel: UILabel!
    @IBOutlet weak var densityUnitLabel: UILabel!
    @IBOutlet weak var densityStackView: UIStackView!
    
    @IBOutlet weak var updateButton: UIBarButtonItem!
    
    @IBOutlet weak var rangeView: UIView!
    @IBOutlet weak var range: UITextField!
    
    
    
    
    var isEdit: Bool = false
    var isCancel: Bool = false
    
    let container = CKContainer.default()
    var privateDatabase: CKDatabase?
    var recordZone: CKRecordZone?
    
    var idsToUpload = [String]()
    var idsToUploadEdit = [String]()
    
    var category = ""
    var activeField: UITextField?
    
    var gear: NSManagedObject?
    var gearID: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isEdit == true {
            if editButton.title == "Edit" {
                cancelButton.title = "Done"
            }
            else {
                cancelButton.title = ""
            }
            navigationController?.isToolbarHidden = false
        }
        else {
            navigationController?.isToolbarHidden = true
        }
        registerKeyboardNotifications()
        switch category {
        case "Slings & Quickdraws":
            densityLabel.isHidden = true
            lengthUnitLabel.text = "cm |"
            rangeView.isHidden = true
        case "Ice Screws":
            densityLabel.isHidden = true
            lengthUnitLabel.text = "cm |"
            rangeView.isHidden = true
        case "Cams":
            lengthLabel.text = "Min:"
            length.placeholder = "mm"
            densityLabel.text = "Max:"
            lengthUnitLabel.isHidden = true
            density.placeholder = "mm"
            densityUnitLabel.text = "mm"
        case "Chocks":
            lengthLabel.text = "Min:"
            length.placeholder = "mm"
            densityLabel.text = "Max:"
            lengthUnitLabel.isHidden = true
            density.placeholder = "mm"
            densityUnitLabel.text = "mm"
            rangeView.isHidden = true
        case "Pitons":
            lengthLabel.text = "Width:"
            length.placeholder = "mm"
            densityStackView.isHidden = true
            lengthUnitLabel.text = "mm"
            rangeView.isHidden = true
        default:
            lengthView.isHidden = true
            rangeView.isHidden = true
    }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deRegisterKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        if gear?.value(forKeyPath: "photo") == nil
        {
            photoImageView.image = UIImage(named: "SelectAPhoto2")
        }
        
        photoScrollView.minimumZoomScale = 1.0
        photoScrollView.maximumZoomScale = 5.0
        
        privateDatabase = container.privateCloudDatabase
        recordZone = CKRecordZone(zoneName: "GearZone")
        
        hardwareDetails.delegate=self
        selfWeight.delegate=self
        manufWeight.delegate=self
        length.delegate=self
        density.delegate=self
        hardwareNotes.delegate=self
        
        self.addDoneButtonOnKeyboard()
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(HardwareViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        //Set up views if editing an existing item.
        if let gear = gear {
            navigationItem.title = gear.value(forKeyPath: "details") as? String
            hardwareDetails.text = gear.value(forKeyPath: "details") as? String
            selfWeight.text = gear.value(forKeyPath: "selfWeight") as? String
            manufWeight.text = gear.value(forKeyPath: "manufWeight") as? String
            length.text = gear.value(forKeyPath: "manufLength") as? String
            density.text = gear.value(forKeyPath: "calculatedDensity") as? String
            range.text = gear.value(forKeyPath: "manufDensity") as? String
            if gear.value(forKeyPath: "photo") != nil {
                let photoData = gear.value(forKeyPath: "photo")
                let image = UIImage(data: photoData as! Data)
                photoImageView.image = image
            }
            else {
                photoImageView.image = UIImage(named: "SelectAPhoto2")
            }
            hardwareNotes.text = gear.value(forKeyPath: "notes") as? String
            if let date = gear.value(forKeyPath: "update") as? Date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let dateString = formatter.string(from: date)
                updateButton.title = "Updated: " + dateString
            }
        }
        if hardwareDetails.text == ""{
            editButton.title = ""
        }
        else{
            saveButton.title = ""
        }
        if hardwareNotes.text == ""{
            hardwareNotes.text = "Enter notes"}
        if hardwareNotes.text == "Enter notes"{
            hardwareNotes.textColor = UIColor.lightGray}
        else{hardwareNotes.textColor = UIColor.black}
        hardwareDetails.becomeFirstResponder()
        switch category{
        case "Locking Carabiners":
            if hardwareDetails.text == ""{
                navigationItem.title = "New Locking Carabiner"}
        case "Non-locking Carabiners":
            if hardwareDetails.text == ""{
                navigationItem.title = "New Non-locking Carabiner"}
        case "Slings & Quickdraws":
            if hardwareDetails.text == ""{
                navigationItem.title = "New Sling/Quickdraw"}
        case "Chocks":
            if hardwareDetails.text == ""{
                navigationItem.title = "New Chock"}
        case "Cams":
            if hardwareDetails.text == ""{
                navigationItem.title = "New Cam"}
        case "Pitons":
            if hardwareDetails.text == ""{
                navigationItem.title = "New Piton"}
        case "Ice Screws":
            if hardwareDetails.text == ""{
                navigationItem.title = "New Ice Screw"}
        case "Other Protection":
            if hardwareDetails.text == ""{
                navigationItem.title = "New Other Protection"}
        case "Harnesses":
            if hardwareDetails.text == ""{
                navigationItem.title = "New Harness"}
        case "Belay & Rappel":
            if hardwareDetails.text == ""{
                navigationItem.title = "New Belay/Rappel"}
        case "Ascenders & Pulleys":
            if hardwareDetails.text == ""{
                navigationItem.title = "New Ascender/Pulley"}
        case "Aid Gear":
            if hardwareDetails.text == ""{
                navigationItem.title = "New Aid Gear"}
        case "Other Hardware":
            if hardwareDetails.text == ""{
                navigationItem.title = "New Other Hardware"}
        default: fatalError()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return saveButton.title == "Save" && editButton.title != "Edit"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
        if hardwareDetails.text != "" {
            saveButton.isEnabled = true}
        if textField == hardwareDetails{
            navigationItem.title = textField.text}
        if category == "Slings & Quickdraws" || category == "Cams" || category == "Ice Screws"{
            updateDensity()
        }
        return
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    //MARK: UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        textView.textContainer.maximumNumberOfLines = 4
        textView.textContainer.lineBreakMode = .byWordWrapping
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let existingLines = textView.text.components(separatedBy: CharacterSet.newlines)
        let newLines = text.components(separatedBy: CharacterSet.newlines)
        let linesAfterChange = existingLines.count + newLines.count - 1
        
        return linesAfterChange <= textView.textContainer.maximumNumberOfLines
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return saveButton.title == "Save" && editButton.title != "Edit"
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter notes"
            textView.textColor = UIColor.lightGray
        }
        if hardwareDetails.text != "" {
            saveButton.isEnabled = true}
    }
    
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true,completion:nil)
    }

    //MARK: UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if editButton.title == "Edit" {
            return photoImageView
        }
        else {
            return nil
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            isCancel = true
            return
        }
        if category == "Slings & Quickdraws" || category == "Cams" || category == "Ice Screws" {
            updateDensity()
        }
        let detailsValue = hardwareDetails.text
        let categoryValue = category
        let majorCategory = "Hardware"
        let selfWeightValue = selfWeight.text
        let manufWeightValue = manufWeight.text
        let lengthValue = length.text
        let densityValue = density.text
        let rangeValue = range.text
        let notesValue = hardwareNotes.text
        if isEdit == false {
            gearID = String(format: "%f", NSDate.timeIntervalSinceReferenceDate)
        }
        let gearIDValue = gearID
        let update = NSDate()
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Gear", in: managedContext)!
        if let gear = gear {
            gear.setValue(detailsValue, forKeyPath: "details")
            gear.setValue(categoryValue, forKeyPath: "category")
            gear.setValue(majorCategory, forKeyPath: "majorCategory")
            gear.setValue(selfWeightValue, forKeyPath: "selfWeight")
            gear.setValue(manufWeightValue, forKeyPath: "manufWeight")
            gear.setValue(lengthValue, forKeyPath: "manufLength")
            gear.setValue(densityValue, forKeyPath: "calculatedDensity")
            gear.setValue(rangeValue, forKeyPath: "manufDensity")
            gear.setValue(notesValue, forKeyPath: "notes")
            gear.setValue(gearIDValue, forKeyPath: "gearID")
            gear.setValue(update, forKeyPath: "update")
            let photo: UIImage?
            let photoData: Data?
            if photoImageView.image == UIImage(named: "SelectAPhoto2") {
                photo = nil
            }
            else {
                photo = photoImageView.image
                photoData = UIImageJPEGRepresentation(photo!, 0.1)
                gear.setValue(photoData, forKeyPath: "photo")
            }
            do {
                try managedContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Error saving CoreData gear: \(nserror), \(nserror.userInfo)")
            }
            uploadEditedGearToCloud(gear: gear)
        }
        else {
            let gear = NSManagedObject(entity: entity, insertInto: managedContext)
            gear.setValue(detailsValue, forKeyPath: "details")
            gear.setValue(categoryValue, forKeyPath: "category")
            gear.setValue(majorCategory, forKeyPath: "majorCategory")
            gear.setValue(selfWeightValue, forKeyPath: "selfWeight")
            gear.setValue(manufWeightValue, forKeyPath: "manufWeight")
            gear.setValue(lengthValue, forKeyPath: "manufLength")
            gear.setValue(densityValue, forKeyPath: "calculatedDensity")
            gear.setValue(rangeValue, forKeyPath: "manufDensity")
            gear.setValue(notesValue, forKeyPath: "notes")
            gear.setValue(gearIDValue, forKeyPath: "gearID")
            gear.setValue(update, forKeyPath: "update")
            let photo: UIImage?
            let photoData: Data?
            if photoImageView.image == UIImage(named: "SelectAPhoto2") {
                photo = nil
            }
            else {
                photo = photoImageView.image
                photoData = UIImageJPEGRepresentation(photo!, 0.1)
                gear.setValue(photoData, forKeyPath: "photo")
            }
            do {
                try managedContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Error saving CoreData gear: \(nserror), \(nserror.userInfo)")
            }
            uploadGearToCloud(gear: gear)
        }
    }
    
    //MARK: Actions
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        hardwareNotes.resignFirstResponder()
        if editButton.title != "Edit"{
            let myAlert = UIAlertController (title: "Add image from:", message: "", preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: .default) {(action) in
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                    imagePicker.mediaTypes = [kUTTypeImage as String]
                    imagePicker.allowsEditing = false
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
            let cameraRollAction = UIAlertAction(title: "Photo Library", style: .default) {(action) in
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                    imagePicker.mediaTypes = [kUTTypeImage as String]
                    imagePicker.allowsEditing = false
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) {(action) in
                self.dismiss(animated:true,completion:nil)
            }
            if let popoverController = myAlert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            activeField?.resignFirstResponder()
            myAlert.addAction(cameraAction)
            myAlert.addAction(cameraRollAction)
            myAlert.addAction(cancelAction)
            self.present(myAlert, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        if let renderedJPEGData = UIImageJPEGRepresentation(selectedImage, 0.0) {
            let compressedImage = UIImage(data: renderedJPEGData)
            self.photoImageView.image=compressedImage
        }
        dismiss(animated:true,completion:nil)
        if hardwareDetails.text != "" {
            saveButton.isEnabled = true}
    }
    
    //MARK: Private methods.
    @IBAction func editClicked(_ sender: Any) {
        if editButton.title == "Edit"{
            saveButton.title = "Save"
            saveButton.isEnabled = false
            editButton.title = "Cancel Editing"
            cancelButton.title = ""
        }
        else{
            saveButton.title = ""
            editButton.title = "Edit"
            cancelButton.title = "Done"
            if let gear = gear {
                navigationItem.title = gear.value(forKeyPath: "details") as? String
                hardwareDetails.text = gear.value(forKeyPath: "details") as? String
                selfWeight.text = gear.value(forKeyPath: "selfWeight") as? String
                manufWeight.text = gear.value(forKeyPath: "manufWeight") as? String
                length.text = gear.value(forKeyPath: "manufLength") as? String
                density.text = gear.value(forKeyPath: "calculatedDensity") as? String
                range.text = gear.value(forKeyPath: "manufDensity") as? String
                if gear.value(forKeyPath: "photo") != nil {
                    let photoData = gear.value(forKeyPath: "photo")
                    let image = UIImage(data: photoData as! Data)
                    photoImageView.image = image
                }
                else {
                    photoImageView.image = UIImage(named: "SelectAPhoto2")
                }
                hardwareNotes.text = gear.value(forKeyPath: "notes") as? String
            }
        }
    }
    @objc func didTapView(){
        self.view.endEditing(true)
    }
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.done, target: self, action: #selector(RopeViewController.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        let notesToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        notesToolbar.barStyle       = UIBarStyle.default
        let notes: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(RopeViewController.notesButtonAction))
        
        var noteItems = [UIBarButtonItem]()
        noteItems.append(flexSpace)
        noteItems.append(notes)
        
        notesToolbar.items = noteItems
        notesToolbar.sizeToFit()
        self.hardwareNotes.inputAccessoryView = notesToolbar
        
        self.selfWeight.inputAccessoryView = doneToolbar
        self.manufWeight.inputAccessoryView = doneToolbar
        self.length.inputAccessoryView = doneToolbar
        self.density.inputAccessoryView = doneToolbar
        self.hardwareDetails.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        switch activeField{
        case hardwareDetails?:
            hardwareDetails.resignFirstResponder()
            selfWeight.becomeFirstResponder()
        case selfWeight?:
            selfWeight.resignFirstResponder()
            manufWeight.becomeFirstResponder()
        case manufWeight?:
            manufWeight.resignFirstResponder()
            if lengthView.isHidden == false {
                length.becomeFirstResponder()
            }
            else {
                hardwareNotes.becomeFirstResponder()
            }
        case length?:
            length.resignFirstResponder()
            if densityStackView.isHidden == false && densityLabel.text == "Max:" {
                density.becomeFirstResponder()
            }
            else {
                hardwareNotes.becomeFirstResponder()
            }
        case density?:
            density.resignFirstResponder()
            hardwareNotes.becomeFirstResponder()
        default:
            activeField?.resignFirstResponder()
        }}
    
    @objc func notesButtonAction() {
        hardwareNotes.resignFirstResponder()
    }
    
    fileprivate func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(HardwareViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HardwareViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc fileprivate func deRegisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: nil)
    }
    @objc fileprivate func keyboardWillShow(notification: NSNotification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let value: NSValue = info.value(forKey: UIKeyboardFrameEndUserInfoKey)
            as! NSValue
        let keyboardSize: CGSize = value.cgRectValue.size
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets: UIEdgeInsets = .zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func updateDensity() {
        var weight: Double?
        var lengthValue: Double?
        switch category {
        case "Slings & Quickdraws", "Ice Screws":
            if selfWeight.text != "" {
                guard let _weight = Double(selfWeight.text!) else {
                    return
                }
                weight = _weight
            }
            else if manufWeight.text != "" {
                guard let _weight = Double(manufWeight.text!) else {
                    return
                }
                weight = _weight
            }
            else {
                density.text = ""
                return
            }
            if length.text != "" {
                guard let _length = Double(length.text!) else {
                    return
                }
                lengthValue = _length
            }
            else {
                density.text = ""
                return
            }
            density.text = String(format: "%.2f", weight!/lengthValue!)
        case "Cams":
            if selfWeight.text != "" {
                guard let _weight = Double(selfWeight.text!) else {
                    return
                }
                weight = _weight
            }
            else if manufWeight.text != "" {
                guard let _weight = Double(manufWeight.text!) else {
                    return
                }
                weight = _weight
            }
            else {
                range.text = ""
                return
            }
            if length.text != "" && density.text != "" {
                guard let minLength = Double(length.text!) else {
                    return
                }
                guard let maxLength = Double(density.text!) else {
                    return
                }
                lengthValue = (minLength + maxLength)/2
            }
            else {
                range.text = ""
                return
            }
            range.text = String(format: "%.2f", weight!/lengthValue!)
        default:
            range.text = ""
            return
        }
    }
}





