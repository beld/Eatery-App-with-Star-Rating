import UIKit
import AMTagListView
import SCLAlertView

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // MARK: Properties
    var meal: Meal?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var tasteRatingView: FloatRatingView!
    @IBOutlet weak var healthRatingView: FloatRatingView!
    @IBOutlet weak var fatRatingView: FloatRatingView!
    @IBOutlet weak var carbRatingView: FloatRatingView!
    @IBOutlet weak var caloryRatingView: FloatRatingView!
    @IBOutlet weak var energyDensityRatingView: FloatRatingView!
    @IBOutlet weak var difficultyRatingView: FloatRatingView!
    @IBOutlet weak var timeRatingView: FloatRatingView!
    @IBOutlet weak var sugarRatingView: FloatRatingView!
    @IBOutlet weak var vitaminRatingView: FloatRatingView!
    @IBOutlet weak var fibreRatingView: FloatRatingView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var tagListView: AMTagListView!
    @IBAction func addTag(sender: AnyObject) {
        let tag = ["delicious", "healthy", "easy", "unhealthy"]
        
        RRTagController.displayTagController(self, tagsString: tag, blockFinish: { (selectedTags, unSelectedTags) -> () in
            // the user finished the selection and returns the separated list Selected and not selected.
            for tag in selectedTags {
                self.tagListView.addTag(tag.textContent)
            }
        }) { () -> () in
            // here the user cancel the selection, nothing is returned.
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置NavigationBar为透明
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(red: 1/255.0, green: 131/255.0, blue: 209/255.0, alpha: 1))
        
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        navigationController!.navigationBar.titleTextAttributes =
            ([NSFontAttributeName: UIFont(name: "BradleyHandITCTT-Bold", size: 15)!,
                NSForegroundColorAttributeName: UIColor.whiteColor()])

        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        // set up views if editing an existing meal
        if let existingMeal = meal {
            navigationItem.title = existingMeal.name
            nameTextField.text = existingMeal.name
            photoImageView.image = existingMeal.photo
            tasteRatingView.rating = existingMeal.tasteRating
            healthRatingView.rating = existingMeal.healthRating
            fatRatingView.rating = existingMeal.fatRating
            carbRatingView.rating = existingMeal.carbRating
            caloryRatingView.rating = existingMeal.caloryRating
            energyDensityRatingView.rating = existingMeal.energyDensityRating
            sugarRatingView.rating = existingMeal.sugarRating
            vitaminRatingView.rating = existingMeal.vitaminRating
            fibreRatingView.rating = existingMeal.fibreRating
            difficultyRatingView.rating = existingMeal.difficultyRating
            timeRatingView.rating = existingMeal.timeRating
            descriptionTextView.text = existingMeal.cookingDescription
        }
        
        descriptionTextView.sizeToFit()
        
        // enable save button only if text field has valid name
        checkValidMealName()
        
        AMTagView.appearance().tagLength = 10
        AMTagView.appearance().textFont = UIFont(name: "Futura", size: 14)
        AMTagView.appearance().tagColor = UIColor(red:0.12, green:0.55, blue:0.84, alpha:1)
        tagListView.addTag("Gericht")
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable save button while editing
        saveButton.enabled = false
    }
    
    func checkValidMealName() {
        // disable the save button if text field is empty
        let text = nameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidMealName()
        navigationItem.title = textField.text
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Navigation
    @IBAction func cancel(sender: UIBarButtonItem) {
        // depending on style of presentation (modal or push), this view
        // controller needs to be dismissed in 2 different ways
        
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func tasteButton(sender: AnyObject) {
        let alert = SCLAlertView()
        alert.showInfo("Geschmack", subTitle: "Bitte den Geschmack diese Gericht nach Ihren Gunsten bewerten, von 0 bis 5")
    }
    
    @IBAction func healthButton(sender: AnyObject) {
        let alert = SCLAlertView()
        alert.showInfo("Gesundheit", subTitle: "Wie gesund ist diese Gericht in Ihrer Meinung, von 0 bis 5")
    }
    
    @IBAction func fatButton(sender: AnyObject) {
        let alert = SCLAlertView()
        alert.showInfo("Fett", subTitle: "Bitte bewerten Sie das Fett dieses Gericht Ihrer Meinung nach, von 0 bis 5")
    }
    
    @IBAction func carbButton(sender: AnyObject) {
        let alert = SCLAlertView()
        alert.showInfo("Kohlenhydrate", subTitle: "Bitte bewerten Sie das Kohlenhydrat dieses Gericht Ihrer Meinung nach, von 0 bis 5")
    }
    
    @IBAction func caloryButton(sender: AnyObject) {
        let alert = SCLAlertView()
        alert.showInfo("Kalorien", subTitle: "Bitte bewerten Sie die Kalorien dieses Gericht Ihrer Meinung nach, von 0 bis 5")
    }
    
    @IBAction func energyDensityButton(sender: AnyObject) {
        let alert = SCLAlertView()
        alert.showInfo("Energiedichte", subTitle: "Bitte bewerten Sie die Energiedichte (Kilokalorien pro Gramm) dieses Gericht Ihrer Meinung nach, von 0 bis 5")
    }
    
    @IBAction func difficultyButton(sender: AnyObject) {
        let alert = SCLAlertView()
        alert.showInfo("Schwierigkeit", subTitle: "Bitte bewerten Sie den Schwierigkeitsgrad dieses Mahl zu bereiten, von 0 bis 5")
    }
    
    @IBAction func timeButton(sender: AnyObject) {
        let alert = SCLAlertView()
        alert.showInfo("Zeit", subTitle: "Bitte bewerten Sie die Zeit, die Sie brauchen diese Mahlzeit zu bereiten, von 0 bis 5")
    }
    
    @IBAction func sugarButton(sender: AnyObject) {
        let alert = SCLAlertView()
        alert.showInfo("Zucker", subTitle: "Bitte bewerten Sie den Zucker dieses Gericht Ihrer Meinung nach, von 0 bis 5")
    }
    @IBAction func vitaminButton(sender: AnyObject) {
        let alert = SCLAlertView()
        alert.showInfo("Kohlenhydrate", subTitle: "Bitte bewerten Sie die Vitamine dieses Gericht Ihrer Meinung nach, von 0 bis 5")
    }
    @IBAction func fibreButton(sender: AnyObject) {
        let alert = SCLAlertView()
        alert.showInfo("Ballaststoffe", subTitle: "Bitte bewerten Sie die Ballaststoffe dieses Gericht Ihrer Meinung nach, von 0 bis 5")
    }
    
    // configure a view controller before it's passed
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = nameTextField.text ?? ""
            let photo = photoImageView.image
            let healthRating = healthRatingView.rating
            let tasteRating = tasteRatingView.rating
            let fatRating = fatRatingView.rating
            let carbRating = carbRatingView.rating
            let caloryRating = caloryRatingView.rating
            let energyDensityRating = energyDensityRatingView.rating
            let sugarRating = sugarRatingView.rating
            let vitaminRating = vitaminRatingView.rating
            let fibreRating = fibreRatingView.rating
            let difficultyRating = difficultyRatingView.rating
            let timeRating = timeRatingView.rating
            let cookingDescription = descriptionTextView.text ?? ""
            
            // set meal to be passed to MealTableViewController after unwind segue
            meal = Meal(name: name, photo: photo, tasteRating:tasteRating, healthRating: healthRating, fatRating: fatRating, carbRating: carbRating, caloryRating: caloryRating, energyDensityRating: energyDensityRating, sugarRating: sugarRating, vitaminRating: vitaminRating, fibreRating: fibreRating, difficultyRating: difficultyRating, timeRating: timeRating, cookingDescription: cookingDescription, elapsedRatingTime: 0)
        }
    }
    
    // MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
}
