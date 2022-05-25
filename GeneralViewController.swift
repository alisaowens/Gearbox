import UIKit

class MiscellaneousViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    //MARK: Properties
    
    @IBOutlet weak var miscellaneousDetails: UITextField!
    @IBOutlet weak var selfWeight: UITextField!
    @IBOutlet weak var manufWeight: UITextField!
    @IBOutlet weak var manufWeightLb: UITextField!
    @IBOutlet weak var manufWeightOz: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var miscellaneousNotes: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var gear: Gear?
    var activeField: UITextField?
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isToolbarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        miscellaneousDetails.delegate=self
        selfWeight.delegate=self
        manufWeight.delegate=self
        manufWeightLb.delegate=self
        manufWeightOz.delegate=self
        miscellaneousNotes.delegate=self
        
        self.addDoneButtonOnKeyboard()
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(MiscellaneousViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        //Set up views if editing an existing Miscellaneous.
        if let gear = gear {
            navigationItem.title = gear.details
            miscellaneousDetails.text = gear.details
            selfWeight.text = gear.selfWeight
            manufWeight.text = gear.manufWeight
            manufWeightLb.text = gear.manufWeightLb
            manufWeightOz.text = gear.manufWeightOz
            photoImageView.image = gear.photo
            miscellaneousNotes.text = gear.notes
        }
        if miscellaneousDetails.text == ""{
            editButton.title = ""
        }
        else{
            saveButton.title = ""
        }
        if miscellaneousNotes.text == ""{
            miscellaneousNotes.text = "Enter notes"}
        if miscellaneousNotes.text == "Enter notes"{
            miscellaneousNotes.textColor = UIColor.lightGray}
        else{miscellaneousNotes.textColor = UIColor.black}
        miscellaneousDetails.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard.
        textField.resignFirstResponder()
        if textField == miscellaneousDetails{
            selfWeight.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return saveButton.title == "Save"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
        if miscellaneousDetails.text != "" {
            saveButton.isEnabled = true}
        if textField == miscellaneousDetails{
            navigationItem.title = textField.text}
        if textField == manufWeightLb || textField == manufWeightOz {
            let manufWeightLbValue: Float?
            let manufWeightOzValue: Float?
            if manufWeightLb.text != "" {
                manufWeightLbValue = Float(manufWeightLb.text!)
            }
            else {manufWeightLbValue = 0}
            if manufWeightOz.text != ""{
                manufWeightOzValue = Float(manufWeightOz.text!)
            }
            else {manufWeightOzValue = 0}
            manufWeight.text = String(format:"%.0f", manufWeightLbValue!*453.592+manufWeightOzValue!*28.3495)}
        return
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Disable the Save button while editing
        saveButton.isEnabled = false
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
    }
    
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true,completion:nil)
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender)
        //Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            return
        }
        let miscellaneousDetailsValue = miscellaneousDetails.text ?? ""
        let selfWeightValue = selfWeight.text
        let manufWeightValue = manufWeight.text
        let manufWeightLbValue = manufWeightLb.text
        let manufWeightOzValue = manufWeightOz.text
        let photo = photoImageView.image
        let miscellaneousNotesValue = miscellaneousNotes.text
        //Set the miscellaneous to be passed to the MiscellaneousTableViewController after the unwind segue.
        gear = Gear(details: miscellaneousDetailsValue, selfWeight: selfWeightValue, manufWeight: manufWeightValue, manufWeightLb: manufWeightLbValue, manufWeightOz: manufWeightOzValue, photo: photo, notes: miscellaneousNotesValue, category: nil, majorCategory: "Miscellaneous", servingSize: nil, calories: nil, fat: nil, carbs: nil, protein: nil, size: nil, capacity: nil, capacityCuIn: nil, diameter: nil, selfLength: nil, manufLength: nil, calculatedDensity:  nil, manufDensity: nil, isSingle: false, isHalf: false, isTwin: false, isStatic: false)
    }
    
    //MARK: Actions
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        miscellaneousDetails.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        if editButton.title != "Edit"{
            present(imagePickerController, animated: true, completion: nil)}
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        photoImageView.image=selectedImage
        dismiss(animated:true,completion:nil)
    }

    @IBAction func editClicked(_ sender: Any) {
        if editButton.title == "Edit"{
            saveButton.title = "Save"
            saveButton.isEnabled = false
            editButton.title = "Cancel Editing"}
        else{
            saveButton.title = ""
            editButton.title = "Edit"
            if let gear = gear {
                navigationItem.title = gear.details
                miscellaneousDetails.text = gear.details
                selfWeight.text = gear.selfWeight
                manufWeight.text = gear.manufWeight
                manufWeightLb.text = gear.manufWeightLb
                manufWeightOz.text = gear.manufWeightOz
                photoImageView.image = gear.photo
                miscellaneousNotes.text = gear.notes
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
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(RopeViewController.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.selfWeight.inputAccessoryView = doneToolbar
        self.manufWeight.inputAccessoryView = doneToolbar
        self.manufWeightLb.inputAccessoryView = doneToolbar
        self.manufWeightOz.inputAccessoryView = doneToolbar
        self.miscellaneousNotes.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        switch activeField{
        case selfWeight?:
            selfWeight.resignFirstResponder()
            manufWeight.becomeFirstResponder()
        case manufWeight?:
            manufWeight.resignFirstResponder()
            manufWeightLb.becomeFirstResponder()
        case manufWeightLb?:
            manufWeightLb.resignFirstResponder()
            manufWeightOz.becomeFirstResponder()
        case manufWeightOz?:
            manufWeightOz.resignFirstResponder()
            miscellaneousNotes.becomeFirstResponder()
        default:
            miscellaneousNotes.resignFirstResponder()
        }}
}



