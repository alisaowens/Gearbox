import UIKit
import CloudKit
import MobileCoreServices
import CoreData

class SkiViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UIScrollViewDelegate {
    //MARK: Properties
    
    @IBOutlet weak var skiDetails: UITextField!
    @IBOutlet weak var selfWeight: UITextField!
    @IBOutlet weak var manufWeight: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var skiNotes: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var photoScrollView: UIScrollView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var minLength: UITextField!
    @IBOutlet weak var maxLength: UITextField!
    @IBOutlet weak var minLengthLabel: UILabel!
    @IBOutlet weak var minLengthUnitLabel: UILabel!
    @IBOutlet weak var minLengthStackView: UIStackView!
    @IBOutlet weak var maxLengthStackView: UIStackView!
    @IBOutlet weak var lengthView: UIView!
    
    @IBOutlet weak var updateButton: UIBarButtonItem!
    
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
        
        if category == "Skis" || category == "Ski Crampons" || category == "Poles" || category == "Bindings" || category == "Skins" {
            selfWeight.placeholder = "g (pair)"
            manufWeight.placeholder = "g (pair)"
        }
        
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
        case "Skis":
            maxLengthStackView.isHidden = true
        case "Probes":
            maxLengthStackView.isHidden = true
        case "Skins":
            maxLengthStackView.isHidden = true
        case "Poles":
            minLengthLabel.text = "Min:"
            minLengthUnitLabel.isHidden = true
        default:
            lengthView.isHidden = true
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
        
        skiDetails.delegate=self
        selfWeight.delegate=self
        manufWeight.delegate=self
        minLength.delegate=self
        maxLength.delegate=self
        skiNotes.delegate=self
        
         self.addDoneButtonOnKeyboard()
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(SkiViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        //Set up views if editing an existing item.
        if let gear = gear {
            navigationItem.title = gear.value(forKeyPath: "details") as? String
            skiDetails.text = gear.value(forKeyPath: "details") as? String
            selfWeight.text = gear.value(forKeyPath: "selfWeight") as? String
            manufWeight.text = gear.value(forKeyPath: "manufWeight") as? String
            minLength.text = gear.value(forKeyPath: "selfLength") as? String
            maxLength.text = gear.value(forKeyPath: "manufLength") as? String
            if gear.value(forKeyPath: "photo") != nil {
                let photoData = gear.value(forKeyPath: "photo")
                let image = UIImage(data: photoData as! Data)
                photoImageView.image = image
            }
            else {
                photoImageView.image = UIImage(named: "SelectAPhoto2")
            }
            skiNotes.text = gear.value(forKeyPath: "notes") as? String
            if let date = gear.value(forKeyPath: "update") as? Date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let dateString = formatter.string(from: date)
                updateButton.title = "Updated: " + dateString
            }
        }
        if skiDetails.text == ""{
            editButton.title = ""
        }
        else{
            saveButton.title = ""
        }
        if skiNotes.text == ""{
            skiNotes.text = "Enter notes"}
        if skiNotes.text == "Enter notes"{
            skiNotes.textColor = UIColor.lightGray}
        else{skiNotes.textColor = UIColor.black}
        skiDetails.becomeFirstResponder()
        switch category{
        case "Skis":
            if skiDetails.text == ""{
                navigationItem.title = "New Skis"}
        case "Skins":
            if skiDetails.text == ""{
                navigationItem.title = "New Skins"}
        case "Poles":
            if skiDetails.text == ""{
                navigationItem.title = "New Poles"}
        case "Ski Crampons":
            if skiDetails.text == ""{
                navigationItem.title = "New Ski Crampons"}
        case "Bindings":
            if skiDetails.text == ""{
                navigationItem.title = "New Bindings"}
        case "Shovels":
            if skiDetails.text == ""{
                navigationItem.title = "New Shovel"}
        case "Probes":
            if skiDetails.text == ""{
                navigationItem.title = "New Probe"}
        case "Transceivers":
            if skiDetails.text == ""{
                navigationItem.title = "New Transceiver"}
        case "Other Ski Gear":
            if skiDetails.text == ""{
                navigationItem.title = "New Other Ski Gear"}
        default: fatalError()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return saveButton.title == "Save" && editButton.title != "Edit"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
        if skiDetails.text != "" {
            saveButton.isEnabled = true}
        if textField == skiDetails{
            navigationItem.title = textField.text}
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
        if skiDetails.text != "" {
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
        let detailsValue = skiDetails.text
        let categoryValue = category
        let majorCategory = "Skigear"
        let selfWeightValue = selfWeight.text
        let manufWeightValue = manufWeight.text
        let minLengthValue = minLength.text
        let maxLengthValue = maxLength.text
        let notesValue = skiNotes.text
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
            gear.setValue(minLengthValue, forKeyPath: "selfLength")
            gear.setValue(maxLengthValue, forKeyPath: "manufLength")
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
            gear.setValue(minLengthValue, forKeyPath: "selfLength")
            gear.setValue(maxLengthValue, forKeyPath: "manufLength")
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
        skiNotes.resignFirstResponder()
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
        if skiDetails.text != "" {
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
                skiDetails.text = gear.value(forKeyPath: "details") as? String
                selfWeight.text = gear.value(forKeyPath: "selfWeight") as? String
                manufWeight.text = gear.value(forKeyPath: "manufWeight") as? String
                minLength.text = gear.value(forKeyPath: "selfLength") as? String
                maxLength.text = gear.value(forKeyPath: "manufLength") as? String
                if gear.value(forKeyPath: "photo") != nil {
                    let photoData = gear.value(forKeyPath: "photo")
                    let image = UIImage(data: photoData as! Data)
                    photoImageView.image = image
                }
                else {
                    photoImageView.image = UIImage(named: "SelectAPhoto2")
                }
                skiNotes.text = gear.value(forKeyPath: "notes") as? String
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
        self.skiNotes.inputAccessoryView = notesToolbar
        
        self.selfWeight.inputAccessoryView = doneToolbar
        self.manufWeight.inputAccessoryView = doneToolbar
        self.skiDetails.inputAccessoryView = doneToolbar
        self.minLength.inputAccessoryView = doneToolbar
        self.maxLength.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        switch activeField{
        case skiDetails?:
            skiDetails.resignFirstResponder()
            selfWeight.becomeFirstResponder()
        case selfWeight?:
            selfWeight.resignFirstResponder()
            manufWeight.becomeFirstResponder()
        case manufWeight?:
            manufWeight.resignFirstResponder()
            if minLengthStackView.isHidden == true {
                skiNotes.becomeFirstResponder()
            }
            else {
                minLength.becomeFirstResponder()
            }
        case minLength?:
            minLength.resignFirstResponder()
            if maxLengthStackView.isHidden == true{
                skiNotes.becomeFirstResponder()
            }
            else {
                maxLength.becomeFirstResponder()
            }
        case maxLength?:
            maxLength.resignFirstResponder()
            skiNotes.becomeFirstResponder()
        default:
            activeField?.resignFirstResponder()
        }}
    
    @objc func notesButtonAction() {
        skiNotes.resignFirstResponder()
    }
    
    fileprivate func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(SkiViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SkiViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
}





