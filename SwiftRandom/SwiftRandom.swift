import Foundation

///  Collection of psuedorandom generators from various statistical distributions.

public struct SwiftRandom {
    
    // MARK: - Binomial distribution
    
    /**
    Performs single Bernoulli trial with given probability of success.
    
    :param: probTrue Probability of success.
    
    :returns: Success or failure as Int: 1 or 0. Returns nil if `probabilityOfSuccess` is not between 0 and 1.
    */
    
    public static func randBool(#probTrue: Double) -> Bool? {
        
        return (probTrue >= 0 && probTrue <= 1) ?
            
            Double(arc4random_uniform(UInt32.max - 1)) / Double(UInt32.max) < probTrue :
            
            nil
        
    }
    
    /**
    Performs series of independent Bernoulli trials with given probability of success.
    
    :param: probTrue Probability of success.
    :param: length Length of sample to generate.
    
    :returns: Array of 1 and 0, which indicate successes and failures. Returns nil if `probabilityOfSuccess` is not between 0 and 1 or `sampleLength` <= 0.
    */
    
    public static func randBools(#probTrue: Double, length: Int) -> [Bool]? {
        
        return (probTrue >= 0 && probTrue <= 1) ?
            
            [Int](0..<length).map {
                
                (_: Int) -> Bool in
                
                (Double(arc4random_uniform(UInt32.max - 1)) / Double(UInt32.max)) < probTrue
                
            } : nil
        
    }
    
    /**
    Simulates symmetric coin tossing experiment.
    
    :param: length Length of sample to generate.
    
    :returns: Array of 1 and 0, which indicate heads and tails. Returns nil if `sampleLength` <= 0.
    */
    
    public static func randBools(length: Int) -> [Bool] {
        
        return (0..<length).map{ (_: Int) -> Bool in arc4random_uniform(2) == 0 }
        
    }
    
    // MARK: - Discrete uniform distribution
    
    /**
    Generates single pseudorandom variable from discrete uniform distribution.
    
    :param: min Left boundary (inclusive) of distribution.
    :param: max Right boundary (inclusive) of distribution.
    
    :returns: Single pseudorandom variable from discrete uniform distribution with given boundaries. Returns nil if `max` <= `min`.
    */
    
    public static func randInt(#min: Int, max: Int) -> Int? {
        
        return max > min ? Int(arc4random_uniform(UInt32(max - min + 1))) + min : nil
        
    }
    
    /**
    Generates array of independent pseudorandom variables from discrete uniform distribution.
    
    :param: min Left boundary (inclusive) of distribution.
    :param: max Right boundary (inclusive) of distribution.
    :param: length Length of sample to generate.
    
    :returns: Array of independent pseudorandom variables from discrete uniform distribution with given boundaries. Returns nil if `max` <= `min` or `sampleLength` <= 0.
    */
    
    public static func randDouble(#min: Int, max: Int, length: Int) -> [Int]? {
        
        return max > min ?
            
            [Int](0..<length).map {
            
                (_: Int) -> Int in self.randInt(min: min, max: max)!
            
            } : nil
        
    }
    
    // MARK: - Continuous uniform distribution
    
    /**
    Generates single pseudorandom variable from continuous uniform distribution.
    
    :param: min Left boundary of distribution.
    :param: max Right boundary of distribution.
    
    :returns: Single pseudorandom variable from continuous uniform distribution with given boundaries. Returns nil if `max` <= `min`.
    */
    
    public static func randDouble(#min: Double, max: Double) -> Double? {
        
        return max > min ?
            
            (max - min) * Double(Double(arc4random()) / Double(UINT32_MAX)) + min : nil
        
    }
    
    /**
    Generates array of independent pseudorandom variables from continuous uniform distribution.
    
    :param: min Left boundary of distribution.
    :param: max Right boundary of distribution.
    :param: length Length of sample to generate.
    
    :returns: Array of independent pseudorandom variables from continuous uniform distribution with given boundaries. Returns nil if `max` <= `min` or `sampleLength` <= 0.
    */
    
    public static func randDoubles(#min: Double, max: Double, length: Int) -> [Double]? {
        
        return max > min ? [Int](0..<length).map {
            
            (_: Int) -> Double in self.randDouble(min: min, max: max)!
            
            } : nil
        
    }
    
    // MARK: - Exponential distribution
    
    /**
    Generates single pseudorandom variable from exponential distribution.
    Function uses inverse transform sampling.
    
    :param: rate Rate parameter of exponential distribution.
    
    :returns: Single pseudorandom variable from exponential distribution with given rate. Returns nil if `rate` <= 0.
    */
    
    public static func randExp(#rate: Double) -> Double? {
        
        return rate > 0 ? -1.0/rate * log(randDouble(min: 0, max: 1)!) : nil
        
    }
    
    /**
    Generates array of independent pseudorandom variables from exponential distribution.
    Function uses inverse transform sampling.
    
    :param: rate Rate parameter of exponential distribution.
    :param: length Length of sample to generate.
    
    :returns: Array of independent pseudorandom variables from exponential distribution with given rate. Returns nil if `rate` <= 0 or `sampleLength` <= 0.
    */
    
    public static func randomExps(#rate: Double, length: Int) -> [Double]? {
        
        return rate > 0 ? (0..<length).map {
            
            (_: Int) -> Double in self.randExp(rate: rate)!
            
            } : nil
        
    }
    
    // MARK: - Normal distribution
    
    /**
    Generates single pseudorandom variable from normal distribution.
    Function uses Box-Muller transform.
    
    :param: mean Mean of normal distribution.
    :param: stdDev Standard deviation of normal distribution.
    
    :returns: Single pseudorandom variable from normal distribution with given mean and standard deviation. Returns nil if `standardDeviation` <= 0.
    */
    
    public static func randNormal(#mean: Double, stdDev: Double) -> Double? {
        
        let r2 = -2.0 * log(randDouble(min: 0, max: 1)!)
        let theta = 2.0 * M_PI * randDouble(min: 0, max: 1)!
        
        return stdDev > 0 ? stdDev * (sqrt(r2) * cos(theta)) + mean : nil
    }
    
    /**
    Generates array of independent pseudorandom variables from normal distribution.
    Function uses Box-Muller transform.
    
    :param: mean Mean of normal distribution.
    :param: stdDev Standard deviation of normal distribution.
    :param: length Length of sample to generate.
    
    :returns: Array of independent pseudorandom variables from normal distribution with given mean and standard deviation. Returns nil if `standardDeviation` <= 0 or `sampleLength` <= 0.
    */
    
    public static func randNormals(#mean: Double, stdDev: Double, length: Int) -> [Double]? {
        
        if stdDev <= 0 { return nil }
        
        var randomSample = [Double]()
        
        while randomSample.count < length {
            
            let r2 = -2.0 * log(self.randDouble(min: 0, max: 1)!)
            let theta = 2.0 * M_PI * self.randDouble(min: 0, max: 1)!
            
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
    
    :returns: Array of length `sampleLength` with elements uniformly sampled from `arrayToSampleFrom`. Returns nil for an empty array or `sampleLength` <= 0.
    */
    
    public static func sampleWithRepeats<T>(items: [T], length: Int) -> [T]? {
        
        return items.isEmpty ? nil :
            
            [Int](0..<length).map {
                
                (_: Int) -> T in items[Int(arc4random_uniform(UInt32(items.count)))]
                
            }
        
    }
    
    /**
    Generates random sample from given array - sampling without replacement.
    Function uses Fisher-Yates shuffling algorithm and returns Array of first `sampleLength` elements.
    
    :param: items The array of any type.
    :param: length The length of output sample.
    
    :returns: Array of first `sampleLength` elements from shuffled array. Returns nil for an empty array or if `sampleLength` <= 0 or `sampleLength` > `arrayToSampleFrom.count`.
    */
    
    public static func sampleWithoutRepeats<T>(var items: [T], length: Int) -> [T]? {
        
        return length >= items.count ? nil :
            
            [UInt32](UInt32(items.count - length)..<UInt32(items.count)).reverse()
                .map { items.removeAtIndex(Int(arc4random_uniform($0))) }
        
    }
    
    /**
    Generates random sample from given array using probabilites given by the user.
    
    :param: items The array of any type.
    :param: probs The array of probabilities.
    :param: length The length of output sample.
    
    :returns: Array of length `sampleLength` with elements sampled from `arrayToSampleFrom` with probabilites from `probabilities`.
    */
    
    public static func weightedSample<T>(items: [T], probs: [Double], length: Int) -> [T] {
        
        let factor = probs.reduce(0, combine: +) / Double(UInt32.max)
        
        if items.isEmpty || items.count != probs.count { return [] }
        
        return (0..<length).map {
            
            _ -> T in
            
            var rnd = factor * Double(arc4random_uniform(UInt32.max - 1))
            
            for (i, p) in zip(items, probs) {
                rnd -= p
                if rnd < 0 { return i }
            }
            
            return items.last!
        }
    }
}