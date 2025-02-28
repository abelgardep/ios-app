//
//  UIColor+Extension.swift
//  ownCloud
//
//  Created by Pablo Carrascal on 15/03/2018.
//  Copyright © 2018 ownCloud GmbH. All rights reserved.
//

/*
 * Copyright (C) 2018, ownCloud GmbH.
 *
 * This code is covered by the GNU Public License Version 3.
 *
 * For distribution utilizing Apple mechanisms please see https://owncloud.org/contribute/iOS-license-exception/
 * You should have received a copy of this license along with this program. If not, see <http://www.gnu.org/licenses/gpl-3.0.en.html>.
 *
 */

import UIKit

extension UIColor {

	public convenience init(red: Int, green: Int, blue: Int, alpha: Float = 1.0) {
		assert(red >= 0 && red <= 255, "Invalid red component")
		assert(green >= 0 && green <= 255, "Invalid green component")
		assert(blue >= 0 && blue <= 255, "Invalid blue component")

		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
	}

	public convenience init(hex unsignedRGBHex: UInt, alpha: Float = 1.0) {
		let rgbHex = Int(unsignedRGBHex)
		self.init(red: (rgbHex >> 16) & 0xFF, green: (rgbHex >> 8) & 0xFF, blue: (rgbHex & 0xFF), alpha: alpha)
	}

	public func blended(withFraction fraction: Double, ofColor blendColor: UIColor) -> UIColor {
		var selfRed : CGFloat = 0, selfGreen : CGFloat  = 0, selfBlue : CGFloat  = 0, selfAlpha : CGFloat = 0
		var blendRed : CGFloat = 0, blendGreen : CGFloat  = 0, blendBlue : CGFloat  = 0, blendAlpha : CGFloat = 0

		self.getRed(&selfRed, green:&selfGreen, blue:&selfBlue, alpha:&selfAlpha)
		blendColor.getRed(&blendRed, green:&blendGreen, blue:&blendBlue, alpha:&blendAlpha)

		return UIColor(red:   CGFloat((Double(selfRed)   * (1.0-fraction)) + (Double(blendRed)   * fraction)),
			       green: CGFloat((Double(selfGreen) * (1.0-fraction)) + (Double(blendGreen) * fraction)),
			       blue:  CGFloat((Double(selfBlue)  * (1.0-fraction)) + (Double(blendBlue)  * fraction)),
			       alpha: CGFloat((Double(selfAlpha) * (1.0-fraction)) + (Double(blendAlpha) * fraction)))
	}

	public func lighter(_ fraction: Double) -> UIColor {
		var selfRed : CGFloat = 0, selfGreen : CGFloat  = 0, selfBlue : CGFloat  = 0, selfAlpha : CGFloat = 0

		self.getRed(&selfRed, green:&selfGreen, blue:&selfBlue, alpha:&selfAlpha)

		return UIColor(red:   CGFloat((Double(selfRed)   * (1.0-fraction)) + fraction),
			       green: CGFloat((Double(selfGreen) * (1.0-fraction)) + fraction),
			       blue:  CGFloat((Double(selfBlue)  * (1.0-fraction)) + fraction),
			       alpha: selfAlpha)
	}

	public func darker(_ fraction: Double) -> UIColor {
		var selfRed : CGFloat = 0, selfGreen : CGFloat  = 0, selfBlue : CGFloat  = 0, selfAlpha : CGFloat = 0

		self.getRed(&selfRed, green:&selfGreen, blue:&selfBlue, alpha:&selfAlpha)

		return UIColor(red:   CGFloat(Double(selfRed)   * (1.0-fraction)),
			       green: CGFloat(Double(selfGreen) * (1.0-fraction)),
			       blue:  CGFloat(Double(selfBlue)  * (1.0-fraction)),
			       alpha: selfAlpha)
	}

	public var greyscale : UIColor {
		var selfRed : CGFloat = 0, selfGreen : CGFloat  = 0, selfBlue : CGFloat  = 0, selfAlpha : CGFloat = 0, greyscale : CGFloat = 0

		self.getRed(&selfRed, green:&selfGreen, blue:&selfBlue, alpha:&selfAlpha)

		greyscale = (selfRed + selfGreen + selfBlue) / 3

		return UIColor(red:   CGFloat(greyscale),
			       green: CGFloat(greyscale),
			       blue:  CGFloat(greyscale),
			       alpha: selfAlpha)
	}

	public var luminance : CGFloat {
		var selfRed : CGFloat = 0, selfGreen : CGFloat  = 0, selfBlue : CGFloat  = 0, selfAlpha : CGFloat = 0
		var luminance : CGFloat = 0

		self.getRed(&selfRed, green:&selfGreen, blue:&selfBlue, alpha:&selfAlpha)

		// Luminance according to https://de.wikipedia.org/wiki/Luminanz
		luminance = selfRed * 0.2126 + selfGreen * 0.7152 + selfBlue * 0.0722

		return luminance
	}

	public func hexString(leadIn: String = "#") -> String {
		var selfRed : CGFloat = 0, selfGreen : CGFloat  = 0, selfBlue : CGFloat  = 0, selfAlpha : CGFloat = 0

		self.getRed(&selfRed, green:&selfGreen, blue:&selfBlue, alpha:&selfAlpha)

		return (String(format: "\(leadIn)%02x%02x%02x", Int(selfRed*255.0), Int(selfGreen*255.0), Int(selfBlue*255.0)))
	}
    
    public func isLight() -> Bool {
        guard let components = cgColor.components, components.count > 2 else {return false}
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return (brightness > 0.5)
    }
}
