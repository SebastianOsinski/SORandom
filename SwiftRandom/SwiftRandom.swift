import Foundation

///  Collection of psuedorandom generators from various statistical distributions.

public struct SwiftRandom {
    
    public static func randomBernoulliTrial(#probabilityOfSuccess: Double) -> Int? {
    
        if probabilityOfSuccess < 0.0 || probabilityOfSuccess > 1.0 {
            return nil
        }
        
        return Int(randomContinuousUniform(min: 0.0, max: 1.0) < probabilityOfSuccess)
    }
    
    public static func randomBinomialArray(#probabilityOfSuccess: Double, sampleLength: Int) -> [Int]? {
        
        if probabilityOfSuccess < 0.0 || probabilityOfSuccess > 1.0 || sampleLength <= 0{
            return nil
        }
        
        var randomSample = [Int](count: sampleLength, repeatedValue: 0)
        
        for i in 0..<sampleLength {
            randomSample[i] = randomBernoulliTrial(probabilityOfSuccess: probabilityOfSuccess)!
        }
        
        return randomSample
    }
    
    public static func coinTossArray(sampleLength: Int) -> [Int]? {
        return randomBinomialArray(probabilityOfSuccess: 0.5, sampleLength: sampleLength)
    }
    
    public static func randomDiscreteUniform(#min: Int, max: Int) -> Int? {
        
        if max <= min {
            return nil
        }
        
        return Int(arc4random_uniform(UInt32(max - min + 1))) + min
    }
    
    public static func randomDiscreteUniformArray(#min: Int, max: Int, sampleLength: Int) -> [Int]? {
        
        if max < min || sampleLength <= 0 {
            return nil
        }
        
        var randomSample = [Int](count: sampleLength, repeatedValue: 0)
        
        for i in 0..<sampleLength {
            randomSample[i] = randomDiscreteUniform(min: min, max: max)!
        }
        
        return randomSample
    }
    
    
    public static func randomContinuousUniform(#min: Double, max: Double) -> Double? {
        
        if(max < min){
            return nil
        }
        
        return (max - min) * Double(Double(arc4random()) / Double(UINT32_MAX)) + min
    }
    
    public static func randomContinuousUniformArray(#min: Double, max: Double, sampleLength: Int) -> [Double]? {
        
        if max < min || sampleLength <= 0 {
            return nil
        }
        
        var randomSample = [Double](count: sampleLength, repeatedValue: 0.0)
        
        for i in 0..<sampleLength {
            randomSample[i] = randomContinuousUniform(min: min, max: max)!
        }
        
        return randomSample
    }
    
    public static func randomExpontential(#rate: Double) -> Double? {
        
        if rate <= 0.0 {
            return nil
        }
        
        return -1.0/rate * log(randomContinuousUniform(min: 0, max: 1)!)
    }
    
    public static func randomExponentialArray(#rate: Double, sampleLength: Int) -> [Double]? {
        
        if rate <= 0 || sampleLength <= 0 {
            return nil
        }
        
        var randomSample = [Double](count: sampleLength, repeatedValue: 0.0)
        
        for i in 0..<sampleLength {
            randomSample[i] = randomExpontential(rate: rate)!
        }

        return randomSample
    }
    
    /**
    Generates single pseudorandom variable from normal distribution. 
    Function uses Box-Muller transform.
    
    :param: mean Mean of normal distribution.
    :standardDeviation Standard deviation of normal distribution.
    
    :returns: Single pseudorandom variable from normal distribution with given mean and standard deviation. Returns nil if `standardDeviation` <= 0.
    */
    
    public static func randomNormal(#mean: Double, standardDeviation: Double) -> Double? {
        
        if standardDeviation <= 0.0 {
            return nil
        }
        
        let u = randomContinuousUniformArray(min: 0, max: 1, sampleLength: 2)!
        let r2 = -2.0 * log(u[0])
        let theta = 2.0 * M_PI * u[1]
        
        return standardDeviation * (sqrt(r2) * cos(theta)) + mean
    }
    
    /**
    Generates array of independent pseudorandom variables from normal distribution.
    Function uses Box-Muller transform.
    
    :param: mean Mean of normal distribution.
    :standardDeviation Standard deviation of normal distribution.
    :sampleLength Length of sample to generate.
    
    :returns: Array of independent pseudorandom variables from normal distribution with given mean and standard deviation. Returns nil if `standardDeviation` <= 0 or if `sampleLength` <= 0.
    */
    
    public static func randomNormalArray(#mean: Double, standardDeviation: Double, sampleLength: Int) -> [Double]? {
        
        if standardDeviation <= 0.0 || sampleLength <= 0 {
            return nil
        }
        if sampleLength == 1 {
            return [randomNormal(mean: mean, standardDeviation: standardDeviation)!]
        }
        
        let numberOfPairs: Int = sampleLength/2
        let u1 = randomContinuousUniformArray(min: 0, max: 1, sampleLength: numberOfPairs)!
        let u2 = randomContinuousUniformArray(min: 0, max: 1, sampleLength: numberOfPairs)!
        
        var randomSample = [Double](count: sampleLength, repeatedValue: 0.0)
        
        var r2: Double
        var theta: Double
        
        var k: Int = 0
        
        for i in 0..<numberOfPairs {
            r2 = -2.0 * log(u1[i])
            theta = 2.0 * M_PI * u2[i]
            
            randomSample[k] = standardDeviation * (sqrt(r2) * cos(theta)) + mean
            k++
            randomSample[k] = standardDeviation * (sqrt(r2) * sin(theta)) + mean
            k++
        }
        
        if(sampleLength%2 == 1){
            randomSample[sampleLength - 1] = randomNormal(mean: mean, standardDeviation: standardDeviation)!
        }
        
        return randomSample
    }
    
    /**
    Generates random sample from given array - sampling with replacement.
    
    :param: arrayToSampleFrom The array of any type.
    :param: sampleLength The length of output sample.
    
    :returns: Array of length `sampleLength` with elements uniformly sampled from `arrayToSampleFrom`. Returns nil for an empty array or if `sampleLength` <= 0.
    */

    
    public static func samplingWithReplacementFromArray<T>(arrayToSampleFrom: [T], sampleLength: Int) -> [T]? {
        
        if arrayToSampleFrom.isEmpty || sampleLength <= 0 {
            return nil
        }
        
        let inputArrayLength = arrayToSampleFrom.count
        var randomSample: [T] = []
        
        for i in 1...sampleLength {
            randomSample.append(arrayToSampleFrom[randomDiscreteUniform(min: 0, max: inputArrayLength - 1)!])
        }
        
        return randomSample
    }
    
    /**
    Generates random sample from given array - sampling without replacement. 
    Function uses Fisher-Yates shuffling algorithm and returns Array of first `sampleLength` elements.
    
    :param: arrayToSampleFrom The array of any type.
    :param: sampleLength The length of output sample.
    
    :returns: Array of first `sampleLength` elements from shuffled array. Returns nil for empty an array or if `sampleLength` <= 0 or `sampleLength` > `arrayToSampleFron.count`.
    */
    
    public static func samplingWithoutReplacementFromArray<T>(var arrayToSampleFrom: [T], sampleLength: Int) -> [T]? {
        
        if arrayToSampleFrom.isEmpty || sampleLength <= 0 || sampleLength > arrayToSampleFrom.count {
            return nil
        }
        
        let inputArrayLength = arrayToSampleFrom.count
        
        for i in 0..<(inputArrayLength - 1) {
            let k = randomDiscreteUniform(min: i, max: inputArrayLength - 1)!
            swap(&arrayToSampleFrom[i], &arrayToSampleFrom[k])
        }
        
        return Array(arrayToSampleFrom[0..<sampleLength])
    }
    
}



















