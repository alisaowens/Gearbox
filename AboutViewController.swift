//
//  AboutViewController.swift
//  GearBox
//
//  Created by Alisa Owens on 1/28/18.
//  Copyright © 2018 AlisaOwens. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var one: UILabel!
    @IBOutlet weak var two: UILabel!
    @IBOutlet weak var three: UILabel!
    @IBOutlet weak var four: UILabel!
    @IBOutlet weak var five: UILabel!
    @IBOutlet weak var six: UILabel!
    @IBOutlet weak var seven: UILabel!
    @IBOutlet weak var eight: UILabel!
    @IBOutlet weak var nine: UILabel!
    @IBOutlet weak var ten: UILabel!
    @IBOutlet weak var eleven: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var clothingLabel: UILabel!
    @IBOutlet weak var sleepingLabel: UILabel!
    @IBOutlet weak var cookingLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var electronicsLabel: UILabel!
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var lightingLabel: UILabel!
    @IBOutlet weak var eyewearLabel: UILabel!
    @IBOutlet weak var footwearLabel: UILabel!
    @IBOutlet weak var hardwareLabel: UILabel!
    @IBOutlet weak var ropeLabel: UILabel!
    @IBOutlet weak var iceLabel: UILabel!
    @IBOutlet weak var skiLabel: UILabel!
    @IBOutlet weak var packLabel: UILabel!
    @IBOutlet weak var helmetLabel: UILabel!
    @IBOutlet weak var miscLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var aboutView: UIView!
    
    @IBAction func cancelButton(_ sender: Any) {
        if aboutView.isHidden == true {
            UIView.animate(withDuration: 0.1){
                self.aboutView.isHidden = false
            }
            cancelButton.setImage(UIImage(named: "Cancel"), for: .normal)
        }
        else {
            UIView.animate(withDuration: 0.1){
                self.aboutView.isHidden = true
            }
            cancelButton.setImage(UIImage(named: "Hamburger"), for: .normal)
        }
    }
    
    let homeText = "Home View: Nils Nielsen climbing Aiguille Verte by the Couturier Couloir, in Chamonix, France."
    let homeRange = NSMakeRange(0, 9)
    
    let clothingText = "Clothing: Colin Haley on the summit of Begguya following the fourth ascent of the Grison-Tedeschi route, in the Central Alaska Range. Photo by Bjørn-Eivind Årtun."
    let clothingRange = NSMakeRange(0, 8)
    
    let sleepingText = "Sleeping Gear: Campsite in a crevasse on a sub-peak of Sultana, Central Alaska Range."
    let sleepingRange = NSMakeRange(0, 13)
    
    let cookingText = "Cooking Gear: Nina Caprez making dinner on the summit of the Aiguille du Fou, in Chamonix, France."
    let cookingRange = NSMakeRange(0, 12)
    
    let foodText = "Food: Packing for a single-push attempt on Begguya's \"Deprivation\" route, Central Alaska Range. Photo by Nils Nielsen."
    let foodRange = NSMakeRange(0, 4)
    
    let electronicText = "Electronics: Jed Brown on the summit of Kun, Indian Himalaya."
    let electronicRange = NSMakeRange(0, 11)
    
    let waterText = "Water Storage: Filling water bottles in the Torre Valley. Photo by Jon Walsh."
    let waterRange = NSMakeRange(0, 13)
    
    let lightingText = "Lighting: Anton Krupicka on the lower portion of the Supercanaleta, west face of Chaltén, Patagonia."
    let lightingRange = NSMakeRange(0, 8)
    
    let eyewearText = "Eyewear: Guillaume Vallot acclimatizing on the normal route of Gasherbrum 2, Karakoram."
    let eyewearRange = NSMakeRange(0, 7)
    
    let footwearText = "Footwear: Colin Haley (and Bjørn-Eivind Årtun’s foot) on the upper slopes of “Dracula,” during the first ascent of the route on the southeast face of Sultana, Central Alaska Range. Photo by Bjørn-Eivind Årtun."
    let footwearRange = NSMakeRange(0, 8)
    
    let hardwareText = "Climbing Hardware: Jorge Ackermann during the first ascent of “El Caracol” on Aguja Standhardt, Patagonia."
    let hardwareRange = NSMakeRange(0, 17)
    
    let ropeText = "Ropes: Nina Caprez rappelling the south face of the Aiguille du Fou, Chamonix, France."
    let ropeRange = NSMakeRange(0, 5)
    
    let iceText = "Ice Gear: Martin Olslund during an ascent of “Tomahawk” on Aguja Standhardt, Patagonia."
    let iceRange = NSMakeRange(0, 8)
    
    let skiText = "Ski Gear: Dave Searle climbing the French side of Mont Dolent before a ski descent down the Italian side, Mont Blanc Massif."
    let skiRange = NSMakeRange(0, 8)
    
    let packText = "Packs: Hélias Millerioux attempting to repeat the British-Nepali route on the south face of Nuptse, Nepal."
    let packRange = NSMakeRange(0, 5)
    
    let helmetText = "Helmets: Rob Smith setting a speed record on the Infinite Spur, south face of Sultana, Central Alaska Range."
    let helmetRange = NSMakeRange(0, 7)
    
    let miscText = "Miscellaneous: Basecamp on the Choktoi Glacier, below the north face of Latok 1."
    let miscRange = NSMakeRange(0, 13)
    
    let aboutText = "About Page: Rolando Garibotti descending Cerro Piergiorgio after the first complete ascent, Patagonia."
    let aboutRange = NSMakeRange(0, 10)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let home = NSMutableAttributedString(string: homeText)
        home.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: homeRange)
        homeLabel.attributedText = home
        
        let clothing = NSMutableAttributedString(string: clothingText)
        clothing.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: clothingRange)
        clothingLabel.attributedText = clothing
        
        let sleeping = NSMutableAttributedString(string: sleepingText)
        sleeping.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: sleepingRange)
        sleepingLabel.attributedText = sleeping
        
        let cooking = NSMutableAttributedString(string: cookingText)
        cooking.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: cookingRange)
        cookingLabel.attributedText = cooking
        
        let food = NSMutableAttributedString(string: foodText)
        food.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: foodRange)
        foodLabel.attributedText = food
        
        let electronic = NSMutableAttributedString(string: electronicText)
        electronic.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: electronicRange)
        electronicsLabel.attributedText = electronic
        
        let water = NSMutableAttributedString(string: waterText)
        water.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: waterRange)
        waterLabel.attributedText = water
        
        let lighting = NSMutableAttributedString(string: lightingText)
        lighting.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: lightingRange)
        lightingLabel.attributedText = lighting
        
        let eyewear = NSMutableAttributedString(string: eyewearText)
        eyewear.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: eyewearRange)
        eyewearLabel.attributedText = eyewear
        
        let footwear = NSMutableAttributedString(string: footwearText)
        footwear.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: footwearRange)
        footwearLabel.attributedText = footwear
        
        let hardware = NSMutableAttributedString(string: hardwareText)
        hardware.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: hardwareRange)
        hardwareLabel.attributedText = hardware
        
        let rope = NSMutableAttributedString(string: ropeText)
        rope.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: ropeRange)
        ropeLabel.attributedText = rope
        
        let ice = NSMutableAttributedString(string: iceText)
        ice.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: iceRange)
        iceLabel.attributedText = ice
        
        let ski = NSMutableAttributedString(string: skiText)
        ski.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: skiRange)
        skiLabel.attributedText = ski
        
        let pack = NSMutableAttributedString(string: packText)
        pack.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: packRange)
        packLabel.attributedText = pack
        
        let helmet = NSMutableAttributedString(string: helmetText)
        helmet.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: helmetRange)
        helmetLabel.attributedText = helmet
        
        let misc = NSMutableAttributedString(string: miscText)
        misc.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: miscRange)
        miscLabel.attributedText = misc
        
        let about = NSMutableAttributedString(string: aboutText)
        about.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: aboutRange)
        aboutLabel.attributedText = about
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
