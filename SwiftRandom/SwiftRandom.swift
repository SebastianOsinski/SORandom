import Foundation

///  Collection of psuedorandom generators from various statistical distributions.

func randBool() -> Bool {
    
    return arc4random_uniform(2) == 0
    
}

// MARK: - Binomial distribution

/**
Performs single Bernoulli trial with given probability of success.

:param: probTrue Probability of success.

:returns: Success or failure as Bool. Returns nil if `probTrue` is not between 0 and 1.
*/

func randBool(probTrue: Double) -> Bool? {
    
    return (probTrue >= 0 && probTrue <= 1) ? randCont() < probTrue : nil
    
}

/**
Performs series of independent Bernoulli trials with given probability of success.

:param: probTrue Probability of success.
:param: length Length of sample to generate.

:returns: Array of Bools. Returns nil if `probTrue` is not between 0 and 1.
*/

func randBools(#probTrue: Double, length: Int) -> [Bool]? {
    
    return (probTrue >= 0 && probTrue <= 1) ? (0..<length).map { _ in randBool(probTrue)! } : nil
    
}

/**
Simulates symmetric coin tossing experiment.

:param: length Length of sample to generate.

:returns: Array of Bools, which indicate heads and tails.
*/

func randBools(length: Int) -> [Bool] {
    
    return (0..<length).map{ _ in randBool() }
    
}

// MARK: - Discrete uniform distribution

/**
Generates single pseudorandom variable from discrete uniform distribution.

:param: min Left boundary (inclusive) of distribution.
:param: max Right boundary (inclusive) of distribution.

:returns: Single pseudorandom variable from discrete uniform distribution with given boundaries. Returns nil if `max` <= `min`.
*/

func randDisc(min: Int, max: Int) -> Int {
    
    return Int(arc4random_uniform(UInt32(abs(max - min)))) + Swift.min(max, min)
    
}

func randDisc(max: Int) -> Int {
    
    return Int(arc4random_uniform(UInt32(max)))
    
}

/**
Generates array of independent pseudorandom variables from discrete uniform distribution.

:param: min Left boundary (inclusive) of distribution.
:param: max Right boundary (inclusive) of distribution.
:param: length Length of sample to generate.

:returns: Array of independent pseudorandom variables from discrete uniform distribution with given boundaries. Returns nil if `max` <= `min` or `length` <= 0.
*/

func randDiscs(#min: Int, max: Int, length: Int) -> [Int]? {
    
    return max > min ?
        
        [Int](0..<length).map { _ in randDisc(min, max) } : nil
    
}



// MARK: - Continuous uniform distribution

/**
Generates single pseudorandom variable from continuous uniform distribution.

:param: min Left boundary of distribution.
:param: max Right boundary of distribution.

:returns: Single pseudorandom variable from continuous uniform distribution with given boundaries. Returns nil if `max` <= `min`.
*/

func randCont() -> Double {
    
    return Double(arc4random_uniform(UInt32.max - 1)) / Double(UInt32.max)
    
}

func randCont(max: Double) -> Double {
    
    return max * Double(arc4random_uniform(UInt32.max - 1)) / Double(UInt32.max)
    
}

func randCont(min: Double, max: Double) -> Double {
    
    return (
        abs(max - min) *
            Double(arc4random_uniform(UInt32.max - 1)) /
            Double(UInt32.max)
        ) + Swift.min(max, min)
    
}

/**
Generates array of independent pseudorandom variables from continuous uniform distribution.

:param: min Left boundary of distribution.
:param: max Right boundary of distribution.
:param: length Length of sample to generate.

:returns: Array of independent pseudorandom variables from continuous uniform distribution with given boundaries.
*/

func randConts(#min: Double, max: Double, length: Int) -> [Double] {
    
    return [Int](0..<length).map { _ in randCont(min, max) }
    
}

// MARK: - Exponential distribution

/**
Generates single pseudorandom variable from exponential distribution.
Function uses inverse transform sampling.

:param: rate Rate parameter of exponential distribution.

:returns: Single pseudorandom variable from exponential distribution with given rate. Returns nil if `rate` <= 0.
*/

func randExp(#rate: Double) -> Double? {
    
    return rate > 0 ? -1.0/rate * log(randCont()) : nil
    
}

/**
Generates array of independent pseudorandom variables from exponential distribution.
Function uses inverse transform sampling.

:param: rate Rate parameter of exponential distribution.
:param: length Length of sample to generate.

:returns: Array of independent pseudorandom variables from exponential distribution with given rate. Returns nil if `rate` <= 0.
*/

func randomExps(#rate: Double, length: Int) -> [Double]? {
    
    return rate > 0 ? (0..<length).map { _ in randExp(rate: rate)! } : nil
    
}

// MARK: - Normal distribution

/**
Generates single pseudorandom variable from normal distribution.
Function uses Box-Muller transform.

:param: mean Mean of normal distribution.
:param: stdDev Standard deviation of normal distribution.

:returns: Single pseudorandom variable from normal distribution with given mean and standard deviation. Returns nil if `stdDev` <= 0.
*/

func randNormal(#mean: Double, stdDev: Double) -> Double? {
    
    return stdDev > 0 ?
        
            stdDev    *
            sqrt(-2.0 * log(   randCont())   *
            cos(  2.0 * M_PI * randCont()) ) +
            mean :
        
        nil
}

/**
Generates array of independent pseudorandom variables from normal distribution.
Function uses Box-Muller transform.

:param: mean Mean of normal distribution.
:param: stdDev Standard deviation of normal distribution.
:param: length Length of sample to generate.

:returns: Array of independent pseudorandom variables from normal distribution with given mean and standard deviation. Returns nil if `stdDev` <= 0.
*/

func randNormals(#mean: Double, stdDev: Double, length: Int) -> [Double]? {
    
    if stdDev <= 0 { return nil }
    
    var randomSample = [Double]()
    
    while randomSample.count < length {
        
        let r2 = -2.0 * log(randCont())
        let theta = 2.0 * M_PI * randCont()
        
        randomSample.append(stdDev * (sqrt(r2) * cos(theta)) + mean)
        randomSample.append(stdDev * (sqrt(r2) * sin(theta)) + mean)
        
    }
    
    if randomSample.count > length { randomSample.removeLast() }
    
    return randomSample
}

// MARK: - Sampling

/**
Generates random sample from given array - sampling with replacement.

:param: items The array of any type.
:param: length The length of output sample.

:returns: Array of length `length` with elements uniformly sampled from `items`. Returns nil for an empty array.
*/

func sampleWithRepeats<T>(items: [T], length: Int) -> [T]? {
    
    return items.isEmpty ? nil : (0..<length).map { _ in items[randDisc(items.count)] }
    
}

/**
Generates random sample from given array - sampling without replacement.

:param: items The array of any type.
:param: length The length of output sample.

:returns: Array of first `length` elements from shuffled array. Returns nil if  `length` > `items.count`.
*/

func sampleWithoutRepeats<T>(var items: [T], length: Int) -> [T]? {
    
    return length > items.count ? nil :
        
        [Int]((items.count - length)..<items.count).reverse()
            
            .map { items.removeAtIndex(randDisc($0)) }
    
}

/**
Generates random sample from given array using probabilites given by the user.

:param: items The array of any type.
:param: probs The array of probabilities.
:param: length The length of output sample.

:returns: Array of length `length` with elements sampled from `items` with probabilites from `probs`.
*/

func weightedSample<T>(items: [T], probs: [Double], length: Int) -> [T] {
    
    if items.isEmpty || items.count != probs.count { return [] }
    
    let factor = probs.reduce(0, combine: +) / Double(UInt32.max)
    
    let itemsAndProbs = zip(items, probs)
    
    return (0..<length).map {
        
        _ in
        
        var rnd = factor * Double(arc4random_uniform(UInt32.max - 1))
        
        for (i, p) in itemsAndProbs {
            rnd -= p
            if rnd < 0 { return i }
        }
        
        return items.last!
    }
}
