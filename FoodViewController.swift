import UIKit
import CloudKit
import MobileCoreServices
import CoreData

class FoodViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UIScrollViewDelegate {
    //MARK: Properties
    @IBOutlet weak var foodDetails: UITextField!
    @IBOutlet weak var servingSize: UITextField!
    @IBOutlet weak var calories: UITextField!
    @IBOutlet weak var caloriesPerGram: UITextField!
    @IBOutlet weak var fat: UITextField!
    @IBOutlet weak var fatPerGram: UITextField!
    @IBOutlet weak var carbs: UITextField!
    @IBOutlet weak var carbsPerGram: UITextField!
    @IBOutlet weak var protein: UITextField!
    @IBOutlet weak var proteinPerGram: UITextField!
    @IBOutlet weak var foodNotes: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoScrollView: UIScrollView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
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
        
        foodDetails.delegate=self
        servingSize.delegate=self
        calories.delegate=self
        fat.delegate=self
        carbs.delegate=self
        protein.delegate=self
        foodNotes.delegate=self
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(FoodViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        self.addDoneButtonOnKeyboard()
        
        //Set up views if editing an existing Food.
        if let gear = gear {
            navigationItem.title = gear.value(forKeyPath: "details") as? String
            foodDetails.text = gear.value(forKeyPath: "details") as? String
            servingSize.text = gear.value(forKeyPath: "selfLength") as? String
            calories.text = gear.value(forKeyPath: "selfWeight") as? String
            fat.text = gear.value(forKeyPath: "manufWeight") as? String
            carbs.text = gear.value(forKeyPath: "calculatedDensity") as? String
            protein.text = gear.value(forKeyPath: "manufDensity") as? String
            if gear.value(forKeyPath: "photo") != nil {
                let photoData = gear.value(forKeyPath: "photo")
                let image = UIImage(data: photoData as! Data)
                photoImageView.image = image
            }
            else {
                photoImageView.image = UIImage(named: "SelectAPhoto2")
            }
            foodNotes.text = gear.value(forKeyPath: "notes") as? String
            if let date = gear.value(forKeyPath: "update") as? Date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let dateString = formatter.string(from: date)
                updateButton.title = "Updated: " + dateString
            }
        }
        if foodDetails.text == ""{
            editButton.title = ""
        }
        else{
            saveButton.title = ""
        }
        if foodNotes.text == ""{
            foodNotes.text = "Enter notes"
        }
        if foodNotes.text == "Enter notes"{
            foodNotes.textColor = UIColor.lightGray}
        else{foodNotes.textColor = UIColor.black}
        updatePerGram()
        foodDetails.becomeFirstResponder()
        switch category {
        case "Bars":
            if foodDetails.text == ""{
                navigationItem.title = "New Bar"}
        case "Gels":
            if foodDetails.text == ""{
                navigationItem.title = "New Gel"}
        case "Powders":
            if foodDetails.text == ""{
                navigationItem.title = "New Powder"}
        case "Freeze-dried":
            if foodDetails.text == ""{
                navigationItem.title = "New Freeze-dried"}
        case "Other Food":
            if foodDetails.text == ""{
                navigationItem.title = "New Other Food"}
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
        if foodDetails.text != "" {
            saveButton.isEnabled = true}
        if textField == foodDetails{
            navigationItem.title = textField.text}
        updatePerGram()
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
        if foodDetails.text != "" {
            saveButton.isEnabled = true}
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
        updatePerGram()
        let detailsValue = foodDetails.text
        let categoryValue = category
        let majorCategory = "Food"
        let selfWeightValue = calories.text
        let manufWeightValue = fat.text
        let selfLengthValue = servingSize.text
        let calculatedDensityValue = carbs.text
        let manufDensityValue = protein.text
        let notesValue = foodNotes.text
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
            gear.setValue(selfLengthValue, forKeyPath: "selfLength")
            gear.setValue(calculatedDensityValue, forKeyPath: "calculatedDensity")
            gear.setValue(manufDensityValue, forKeyPath: "manufDensity")
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
            gear.setValue(selfLengthValue, forKeyPath: "selfLength")
            gear.setValue(calculatedDensityValue, forKeyPath: "calculatedDensity")
            gear.setValue(manufDensityValue, forKeyPath: "manufDensity")
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
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true,completion:nil)
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        foodNotes.resignFirstResponder()
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
        if foodDetails.text != "" {
            saveButton.isEnabled = true}
    }

    
    @IBAction func enterServingSize(_ sender: Any) {
        if let servingSizeValue = Double(servingSize.text!){
            if let caloriesValue = Double(calories.text!){
                caloriesPerGram.text = String(format:"%.1f", caloriesValue / servingSizeValue)}
            if let fatValue = Double(fat.text!){
                fatPerGram.text = String(format:"%.1f", fatValue / servingSizeValue)}
            if let carbsValue = Double(carbs.text!){
                carbsPerGram.text = String(format:"%.1f", carbsValue / servingSizeValue)}
            if let proteinValue = Double(protein.text!){
                proteinPerGram.text = String(format:"%.1f", proteinValue / servingSizeValue)}
        }}
    
    @IBAction func enterCalories(_ sender: Any) {
        if calories.text! == ""{
            caloriesPerGram.text = ""}
        else if let servingSizeValue = Double(servingSize.text!){
            if let caloriesValue = Double(calories.text!){
                caloriesPerGram.text = String(format:"%.1f", caloriesValue / servingSizeValue)}
        }}
    
    @IBAction func enterFat(_ sender: Any) {
        if fat.text! == ""{
            fatPerGram.text = ""}
        else if let servingSizeValue = Double(servingSize.text!){
            if let fatValue = Double(fat.text!){
                fatPerGram.text = String(format:"%.1f", fatValue / servingSizeValue)}
        }}
    
    @IBAction func enterCarbs(_ sender: Any) {
        if carbs.text! == ""{
            carbsPerGram.text = ""}
        else if let servingSizeValue = Double(servingSize.text!){
            if let carbsValue = Double(carbs.text!){
                carbsPerGram.text = String(format:"%.1f", carbsValue / servingSizeValue)}
        }}
    
    @IBAction func enterProtein(_ sender: Any) {
        if protein.text! == ""{
            proteinPerGram.text = ""}
        else if let servingSizeValue = Double(servingSize.text!){
            if let proteinValue = Double(protein.text!){
                proteinPerGram.text = String(format:"%.1f", proteinValue / servingSizeValue)}
        }}
    
    //MARK: Private methods.
    func updatePerGram(){
        if let servingSizeValue = Double(servingSize.text!){
            if let caloriesValue = Double(calories.text!){
                caloriesPerGram.text = String(format:"%.1f", caloriesValue / servingSizeValue)}
            if let fatValue = Double(fat.text!){
                fatPerGram.text = String(format:"%.f", fatValue / servingSizeValue*100)}
            if let carbsValue = Double(carbs.text!){
                carbsPerGram.text = String(format:"%.f", carbsValue / servingSizeValue*100)}
            if let proteinValue = Double(protein.text!){
                proteinPerGram.text = String(format:"%.f", proteinValue / servingSizeValue*100)}
        }}
    
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
                foodDetails.text = gear.value(forKeyPath: "details") as? String
                servingSize.text = gear.value(forKeyPath: "selfLength") as? String
                calories.text = gear.value(forKeyPath: "selfWeight") as? String
                fat.text = gear.value(forKeyPath: "manufWeight") as? String
                carbs.text = gear.value(forKeyPath: "calculatedDensity") as? String
                protein.text = gear.value(forKeyPath: "manufDensity") as? String
                if gear.value(forKeyPath: "photo") != nil {
                    let photoData = gear.value(forKeyPath: "photo")
                    let image = UIImage(data: photoData as! Data)
                    photoImageView.image = image
                }
                else {
                    photoImageView.image = UIImage(named: "SelectAPhoto2")
                }
                foodNotes.text = gear.value(forKeyPath: "notes") as? String
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
        self.foodNotes.inputAccessoryView = notesToolbar
        
        self.servingSize.inputAccessoryView = doneToolbar
        self.calories.inputAccessoryView = doneToolbar
        self.fat.inputAccessoryView = doneToolbar
        self.carbs.inputAccessoryView = doneToolbar
        self.protein.inputAccessoryView = doneToolbar
        self.foodDetails.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        switch activeField{
        case foodDetails?:
            foodDetails.resignFirstResponder()
            servingSize.becomeFirstResponder()
        case servingSize?:
            servingSize.resignFirstResponder()
            calories.becomeFirstResponder()
        case calories?:
            calories.resignFirstResponder()
            fat.becomeFirstResponder()
        case fat?:
            fat.resignFirstResponder()
            carbs.becomeFirstResponder()
        case carbs?:
            carbs.resignFirstResponder()
            protein.becomeFirstResponder()
        case protein?:
            protein.resignFirstResponder()
            foodNotes.becomeFirstResponder()
        default:
            activeField?.resignFirstResponder()
        }}
    
    @objc func notesButtonAction() {
        foodNotes.resignFirstResponder()
    }
    
    fileprivate func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(FoodViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FoodViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
