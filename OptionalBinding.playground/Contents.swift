import UIKit

var str = "Hello, playground"

func cookDurationForMedSteak(thicknessString: String) {
    if let steakThickness = Double(thicknessString) {
        let cookEachside = steakThickness * 0.5
        print("Cook each side for \(cookEachside) mins")
    } else {
        print("Invald entry")
    }
}

cookDurationForMedSteak(thicknessString: "3")
cookDurationForMedSteak(thicknessString: "two")
