import UIKit
import CloudKit
import MobileCoreServices
import CoreData

class RopeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UIScrollViewDelegate {
    //MARK: Properties
    @IBOutlet weak var ropeDetails: UITextField!
    @IBOutlet weak var selfLength: UITextField!
    @IBOutlet weak var selfWeight: UITextField!
    @IBOutlet weak var manufLength: UITextField!
    @IBOutlet weak var manufWeight: UITextField!
    @IBOutlet weak var diameter: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var singleButton: UIButton!
    @IBOutlet weak var halfButton: UIButton!
    @IBOutlet weak var twinButton: UIButton!
    @IBOutlet weak var staticButton: UIButton!
    @IBOutlet weak var calculatedDensity: UITextField!
    @IBOutlet weak var manufDensity: UITextField!
    @IBOutlet weak var ropeNotes: UITextView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var updateButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!

    var isSingle: Bool = false
    var isHalf: Bool = false
    var isTwin: Bool = false
    var isStatic: Bool = false
    
    @IBOutlet weak var photoScrollView: UIScrollView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var isEdit: Bool = false
    var isCancel: Bool = false
    
    let container = CKContainer.default()
    var privateDatabase: CKDatabase?
    var recordZone: CKRecordZone?
    
    var idsToUpload = [String]()
    var idsToUploadEdit = [String]()
    
    var defaultType = ""
    var activeField: UITextField?
    
    var ropeLength: String = ""
    var ropeWeight: String = ""
    
    var gear: NSManagedObject?
    var gearID: String?
    
    @IBAction func singleClicked(_ sender: Any) {
        if editButton.title != "Edit"{
        if isSingle == true{
            isSingle = false
        }
        else{isSingle = true}
        toggleSingle()
        updateSaveButtonState()}
    }
    @IBAction func halfClicked(_ sender: Any) {
        if editButton.title != "Edit"{
        if isHalf == true{
            isHalf = false
        }
        else{isHalf = true}
       toggleHalf()
        updateSaveButtonState()}
    }
    @IBAction func twinClicked(_ sender: Any) {
        if editButton.title != "Edit"{
        if isTwin == true{
            isTwin = false
        }
        else{isTwin = true}
       toggleTwin()
        updateSaveButtonState()}
    }
    @IBAction func staticClicked(_ sender: Any) {
        if editButton.title != "Edit"{
        if isStatic == true{
            isStatic = false
        }
        else{isStatic = true}
       toggleStatic()
        updateSaveButtonState()}
    }
    
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
        
        ropeDetails.delegate=self
        selfLength.delegate=self
        selfWeight.delegate=self
        manufLength.delegate=self
        manufWeight.delegate=self
        calculatedDensity.delegate=self
        manufDensity.delegate=self
        diameter.delegate=self
        ropeNotes.delegate=self
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(RopeViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        self.addDoneButtonOnKeyboard()
        
        //Set up views if editing an existing Rope.
        if let gear = gear {
            navigationItem.title = gear.value(forKeyPath: "details") as? String
            ropeDetails.text = gear.value(forKeyPath: "details") as? String
            if gear.value(forKeyPath: "isSingle") as? Bool != nil {
                self.isSingle = gear.value(forKeyPath: "isSingle") as! Bool
            }
            if gear.value(forKeyPath: "isHalf") as? Bool != nil {
                self.isHalf = gear.value(forKeyPath: "isHalf") as! Bool
            }
            if gear.value(forKeyPath: "isTwin") as? Bool != nil {
                self.isTwin = gear.value(forKeyPath: "isTwin") as! Bool
            }
            if gear.value(forKeyPath: "isStatic") as? Bool != nil {
                self.isStatic = gear.value(forKeyPath: "isStatic") as! Bool
            }
            selfLength.text = gear.value(forKeyPath: "selfLength") as? String
            selfWeight.text = gear.value(forKeyPath: "selfWeight") as? String
            manufLength.text = gear.value(forKeyPath: "manufLength") as? String
            manufWeight.text = gear.value(forKeyPath: "manufWeight") as? String
            calculatedDensity.text = gear.value(forKeyPath: "calculatedDensity") as? String
            manufDensity.text = gear.value(forKeyPath: "manufDensity") as? String
            diameter.text = gear.value(forKeyPath: "size") as? String
            if gear.value(forKeyPath: "photo") != nil {
                let photoData = gear.value(forKeyPath: "photo")
                let image = UIImage(data: photoData as! Data)
                photoImageView.image = image
            }
            ropeNotes.text = gear.value(forKeyPath: "notes") as? String
            if let date = gear.value(forKeyPath: "update") as? Date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let dateString = formatter.string(from: date)
                updateButton.title = "Updated: " + dateString
            }
        }
        if ropeDetails.text == ""{
            editButton.title = ""
        }
        else{
            saveButton.title = ""
        }
        if ropeNotes.text == ""{
            ropeNotes.text = "Enter notes"}
        if ropeNotes.text == "Enter notes"{
            ropeNotes.textColor = UIColor.lightGray}
        else{ropeNotes.textColor = UIColor.black}
        updateLength()
        updateWeight()
        updateDensity()
        ropeDetails.becomeFirstResponder()
        switch defaultType{
        case "Single":
            isSingle = true
        case "Half":
            isHalf = true
        case "Twin":
            isTwin = true
        case "Static":
            isStatic = true
        default: fatalError()
    }
        toggleSingle()
        toggleHalf()
        toggleTwin()
        toggleStatic()
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
        return saveButton.title == "Save"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
        if ropeDetails.text != "" {
            updateSaveButtonState()}
        if textField == ropeDetails{
            navigationItem.title = textField.text}
        updateLength()
        updateWeight()
        updateDensity()
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
        updateSaveButtonState()
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
        updateLength()
        updateWeight()
        updateDensity()
        
        let detailsValue = ropeDetails.text
        let majorCategory = "Ropes"
        let isSingleValue = self.isSingle
        let isHalfValue = self.isHalf
        let isTwinValue = self.isTwin
        let isStaticValue = self.isStatic
        let selfWeightValue = selfWeight.text
        let manufWeightValue = manufWeight.text
        let selfLengthValue = selfLength.text
        let manufLengthValue = manufLength.text
        let calculatedDensityValue = calculatedDensity.text
        let manufDensityValue = manufDensity.text
        let sizeValue = diameter.text
        let notesValue = ropeNotes.text
        if isEdit == false {
            gearID = String(format: "%f", NSDate.timeIntervalSinceReferenceDate)
        }
        let gearIDValue = gearID
        let update = NSDate()
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Gear", in: managedContext)!
        
        if let gear = gear {
            gear.setValue(detailsValue, forKeyPath: "details")
            gear.setValue(majorCategory, forKeyPath: "majorCategory")
            gear.setValue(isSingleValue, forKeyPath: "isSingle")
            gear.setValue(isHalfValue, forKeyPath: "isHalf")
            gear.setValue(isTwinValue, forKeyPath: "isTwin")
            gear.setValue(isStaticValue, forKeyPath: "isStatic")
            gear.setValue(selfWeightValue, forKeyPath: "selfWeight")
            gear.setValue(manufWeightValue, forKeyPath: "manufWeight")
            gear.setValue(selfLengthValue, forKeyPath: "selfLength")
            gear.setValue(manufLengthValue, forKeyPath: "manufLength")
            gear.setValue(calculatedDensityValue, forKeyPath: "calculatedDensity")
            gear.setValue(manufDensityValue, forKeyPath: "manufDensity")
            gear.setValue(sizeValue, forKeyPath: "size")
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
            gear.setValue(majorCategory, forKeyPath: "majorCategory")
            gear.setValue(isSingleValue, forKeyPath: "isSingle")
            gear.setValue(isHalfValue, forKeyPath: "isHalf")
            gear.setValue(isTwinValue, forKeyPath: "isTwin")
            gear.setValue(isStaticValue, forKeyPath: "isStatic")
            gear.setValue(selfWeightValue, forKeyPath: "selfWeight")
            gear.setValue(manufWeightValue, forKeyPath: "manufWeight")
            gear.setValue(selfLengthValue, forKeyPath: "selfLength")
            gear.setValue(manufLengthValue, forKeyPath: "manufLength")
            gear.setValue(calculatedDensityValue, forKeyPath: "calculatedDensity")
            gear.setValue(manufDensityValue, forKeyPath: "manufDensity")
            gear.setValue(sizeValue, forKeyPath: "size")
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
        ropeNotes.resignFirstResponder()
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
            self.photoImageView.image=selectedImage
            dismiss(animated:true,completion:nil)
            updateSaveButtonState()
    }
    
    //MARK: Private methods.
    private func updateSaveButtonState() {
        let hasAType = isSingle == true || isHalf == true || isTwin == true || isStatic == true
        if ropeDetails.text != "" && hasAType{
            saveButton.isEnabled = true}
    }
    
    func toggleSingle() {
        if isSingle == true{
            singleButton.backgroundColor = UIColor.blue}
        else{
            singleButton.backgroundColor = UIColor.lightGray}
    }
    func toggleHalf(){
        if isHalf == true{
            halfButton.backgroundColor = UIColor.blue}
        else{
            halfButton.backgroundColor = UIColor.lightGray}
    }
    func toggleTwin(){
        if isTwin == true{
            twinButton.backgroundColor = UIColor.blue}
        else{
            twinButton.backgroundColor = UIColor.lightGray}
    }
    func toggleStatic(){
        if isStatic == true{
            staticButton.backgroundColor = UIColor.blue}
        else{
            staticButton.backgroundColor = UIColor.lightGray}
    }
    
    func updateLength(){
        if selfLength.text != "" {
            ropeLength = selfLength.text!
        }
        else if manufLength.text != "" {
            ropeLength = manufLength.text!
        }
        else {
            ropeLength = "0.0"
        }
    }
    
    func updateWeight(){
        if selfWeight.text != "" {
            ropeWeight = selfWeight.text!
        }
        else if manufWeight.text != "" {
            ropeWeight = manufWeight.text!
        }
        else {
            ropeWeight = "0.0"
        }
    }
    
    func updateDensity() {
        if let ropeLengthValue = Double(ropeLength){
            if let ropeWeightValue = Double(ropeWeight){
                if ropeLengthValue > 0 && ropeWeightValue > 0 {
                calculatedDensity.text = String(format: "%.1f", ropeWeightValue/ropeLengthValue)
                }
                else {
                    calculatedDensity.text = ""
                }
            }
        }
        if selfLength.text == "" || selfWeight.text == "" {
            calculatedDensity.textColor = UIColor(red: 0.498, green: 0, blue: 0, alpha: 1)}
        else{
            calculatedDensity.textColor = UIColor.black}
        }
    
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
                ropeDetails.text = gear.value(forKeyPath: "details") as? String
                if gear.value(forKeyPath: "isSingle") as? Bool != nil {
                    self.isSingle = gear.value(forKeyPath: "isSingle") as! Bool
                }
                if gear.value(forKeyPath: "isHalf") as? Bool != nil {
                    self.isHalf = gear.value(forKeyPath: "isHalf") as! Bool
                }
                if gear.value(forKeyPath: "isTwin") as? Bool != nil {
                    self.isTwin = gear.value(forKeyPath: "isTwin") as! Bool
                }
                if gear.value(forKeyPath: "isStatic") as? Bool != nil {
                    self.isStatic = gear.value(forKeyPath: "isStatic") as! Bool
                }
                selfLength.text = gear.value(forKeyPath: "selfLength") as? String
                selfWeight.text = gear.value(forKeyPath: "selfWeight") as? String
                manufLength.text = gear.value(forKeyPath: "manufLength") as? String
                manufWeight.text = gear.value(forKeyPath: "manufWeight") as? String
                calculatedDensity.text = gear.value(forKeyPath: "calculatedDensity") as? String
                manufDensity.text = gear.value(forKeyPath: "manufDensity") as? String
                diameter.text = gear.value(forKeyPath: "size") as? String
                if gear.value(forKeyPath: "photo") != nil {
                    let photoData = gear.value(forKeyPath: "photo")
                    let image = UIImage(data: photoData as! Data)
                    photoImageView.image = image
                }
                else {
                    photoImageView.image = UIImage(named: "SelectAPhoto2")
                }
                ropeNotes.text = gear.value(forKeyPath: "notes") as? String
            }
            toggleSingle()
            toggleHalf()
            toggleTwin()
            toggleStatic()
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
        self.ropeNotes.inputAccessoryView = notesToolbar
        
        self.ropeDetails.inputAccessoryView = doneToolbar
        self.diameter.inputAccessoryView = doneToolbar
        self.selfWeight.inputAccessoryView = doneToolbar
        self.manufWeight.inputAccessoryView = doneToolbar
        self.selfLength.inputAccessoryView = doneToolbar
        self.manufLength.inputAccessoryView = doneToolbar
        self.manufDensity.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonAction() {
        switch activeField{
        case ropeDetails?:
            ropeDetails.resignFirstResponder()
            diameter.becomeFirstResponder()
        case diameter?:
            diameter.resignFirstResponder()
            selfWeight.becomeFirstResponder()
        case selfWeight?:
            selfWeight.resignFirstResponder()
            manufWeight.becomeFirstResponder()
        case manufWeight?:
            manufWeight.resignFirstResponder()
            selfLength.becomeFirstResponder()
        case selfLength?:
            selfLength.resignFirstResponder()
            manufLength.becomeFirstResponder()
        case manufLength?:
            manufLength.resignFirstResponder()
            manufDensity.becomeFirstResponder()
        case manufDensity?:
            manufDensity.resignFirstResponder()
            ropeNotes.becomeFirstResponder()
        default:
            activeField?.resignFirstResponder()
        }}
    
    @objc func notesButtonAction() {
        ropeNotes.resignFirstResponder()
    }
    
    fileprivate func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(RopeViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RopeViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
