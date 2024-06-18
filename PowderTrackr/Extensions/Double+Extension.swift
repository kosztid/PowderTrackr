import Foundation

extension Double {
    func rounded(toDecimalPlaces places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        return (self * multiplier).rounded() / multiplier
    }

    func roundUp(to base: Double) -> Self {
        ceil(self / base) * base
    }
}
