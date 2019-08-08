//  Copyright © 2019 We Are Mobile First.

extension Double {
    func power(to exponent: Int) -> Double {
        guard exponent > 0 else { return 1 }
        return self * power(to: exponent - 1)
    }

    init(HHMMSS: [String]) {
        guard !HHMMSS.isEmpty else { self.init(0); return }
        var array = HHMMSS
        var value: Double = 0
        var index = 0
        while let lastComponent = array.last {
            value += (Double(lastComponent) ?? 0.0) * 60.0.power(to: index)
            index += 1
            array = array.dropLast()
        }
        self.init(value)
    }
}
