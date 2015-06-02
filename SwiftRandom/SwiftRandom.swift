import Foundation

///  Collection of psuedorandom generators from various statistical distributions.


    
// MARK: - Binomial distribution

/**
Performs single Bernoulli trial with given probability of success.
    
:param: probabilityOfSuccess Probability of success.
    
:returns: Success or failure as Int: 1 or 0. Returns nil if `probabilityOfSuccess` is not between 0 and 1.
*/
    
public func randomBernoulliTrial(#probabilityOfSuccess: Double) -> Int? {
    
    if probabilityOfSuccess < 0.0 || probabilityOfSuccess > 1.0 {
        return nil
    }
    
    return Int(randomContinuousUniform(min: 0.0, max: 1.0) < probabilityOfSuccess)
}

/**
Performs series of independent Bernoulli trials with given probability of success.

:param: probabilityOfSuccess Probability of success.
:param: sampleLength Length of sample to generate.

:returns: Array of 1 and 0, which indicate successes and failures. Returns nil if `probabilityOfSuccess` is not between 0 and 1 or `sampleLength` <= 0.
*/

public func randomBinomialArray(#probabilityOfSuccess: Double, #sampleLength: Int) -> [Int]? {
    
    if probabilityOfSuccess < 0.0 || probabilityOfSuccess > 1.0 || sampleLength <= 0{
        return nil
    }
    
    var randomSample = [Int](count: sampleLength, repeatedValue: 0)
    
    for i in 0..<sampleLength {
        randomSample[i] = randomBernoulliTrial(probabilityOfSuccess: probabilityOfSuccess)!
    }
    
    return randomSample
}

/**
Simulates symmetric coin tossing experiment.

:param: sampleLength Length of sample to generate.

:returns: Array of 1 and 0, which indicate heads and tails. Returns nil if `sampleLength` <= 0.
*/

public func randomCoinTossArray(sampleLength: Int) -> [Int]? {
    return randomBinomialArray(probabilityOfSuccess: 0.5, sampleLength: sampleLength)
}

// MARK: - Discrete uniform distribution

/**
Generates single pseudorandom variable from discrete uniform distribution.

:param: min Left boundary (inclusive) of distribution.
:param: max Right boundary (inclusive) of distribution.

:returns: Single pseudorandom variable from discrete uniform distribution with given boundaries. Returns nil if `max` <= `min`.
*/

public func randomDiscreteUniform(#min: Int, #max: Int) -> Int? {
    
    if max <= min {
        return nil
    }
    
    return Int(arc4random_uniform(UInt32(max - min + 1))) + min
}

/**
Generates array of independent pseudorandom variables from discrete uniform distribution.

:param: min Left boundary (inclusive) of distribution.
:param: max Right boundary (inclusive) of distribution.
:param: sampleLength Length of sample to generate.

:returns: Array of independent pseudorandom variables from discrete uniform distribution with given boundaries. Returns nil if `max` <= `min` or `sampleLength` <= 0.
*/

public func randomDiscreteUniformArray(#min: Int, #max: Int, #sampleLength: Int) -> [Int]? {
    
    if max <= min || sampleLength <= 0 {
        return nil
    }
    
    var randomSample = [Int](count: sampleLength, repeatedValue: 0)
    
    for i in 0..<sampleLength {
        randomSample[i] = randomDiscreteUniform(min: min, max: max)!
    }
    
    return randomSample
}

// MARK: - Continuous uniform distribution

/**
Generates single pseudorandom variable from continuous uniform distribution.

:param: min Left boundary of distribution.
:param: max Right boundary of distribution.

:returns: Single pseudorandom variable from continuous uniform distribution with given boundaries. Returns nil if `max` <= `min`.
*/

public func randomContinuousUniform(#min: Double, #max: Double) -> Double? {
    
    if(max <= min){
        return nil
    }
    
    return (max - min) * Double(Double(arc4random()) / Double(UINT32_MAX)) + min
}

/**
Generates array of independent pseudorandom variables from continuous uniform distribution.

:param: min Left boundary of distribution.
:param: max Right boundary of distribution.
:param: sampleLength Length of sample to generate.

:returns: Array of independent pseudorandom variables from continuous uniform distribution with given boundaries. Returns nil if `max` <= `min` or `sampleLength` <= 0.
*/

public func randomContinuousUniformArray(#min: Double, #max: Double, #sampleLength: Int) -> [Double]? {
    
    if max <= min || sampleLength <= 0 {
        return nil
    }
    
    var randomSample = [Double](count: sampleLength, repeatedValue: 0.0)
    
    for i in 0..<sampleLength {
        randomSample[i] = randomContinuousUniform(min: min, max: max)!
    }
    
    return randomSample
}

// MARK: - Exponential distribution

/**
Generates single pseudorandom variable from exponential distribution.
Function uses inverse transform sampling.

:param: rate Rate parameter of exponential distribution.

:returns: Single pseudorandom variable from exponential distribution with given rate. Returns nil if `rate` <= 0.
*/

public func randomExpontential(#rate: Double) -> Double? {
    
    if rate <= 0.0 {
        return nil
    }
    
    return -1.0/rate * log(randomContinuousUniform(min: 0, max: 1)!)
}

/**
Generates array of independent pseudorandom variables from exponential distribution.
Function uses inverse transform sampling.

:param: rate Rate parameter of exponential distribution.
:param: sampleLength Length of sample to generate.

:returns: Array of independent pseudorandom variables from exponential distribution with given rate. Returns nil if `rate` <= 0 or `sampleLength` <= 0.
*/

public func randomExponentialArray(#rate: Double, #sampleLength: Int) -> [Double]? {
    
    if rate <= 0 || sampleLength <= 0 {
        return nil
    }
    
    var randomSample = [Double](count: sampleLength, repeatedValue: 0.0)
    
    for i in 0..<sampleLength {
        randomSample[i] = randomExpontential(rate: rate)!
    }
    
    return randomSample
}

// MARK: - Normal distribution

/**
Generates single pseudorandom variable from normal distribution.
Function uses Box-Muller transform.

:param: mean Mean of normal distribution.
:param: standardDeviation Standard deviation of normal distribution.

:returns: Single pseudorandom variable from normal distribution with given mean and standard deviation. Returns nil if `standardDeviation` <= 0.
*/

public func randomNormal(#mean: Double, #standardDeviation: Double) -> Double? {
    
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
:param: standardDeviation Standard deviation of normal distribution.
:param: sampleLength Length of sample to generate.

:returns: Array of independent pseudorandom variables from normal distribution with given mean and standard deviation. Returns nil if `standardDeviation` <= 0 or `sampleLength` <= 0.
*/

public func randomNormalArray(#mean: Double, #standardDeviation: Double, #sampleLength: Int) -> [Double]? {
    
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

// MARK: - Sampling

/**
Generates random sample from given array - sampling with replacement.

:param: arrayToSampleFrom The array of any type.
:param: sampleLength The length of output sample.

:returns: Array of length `sampleLength` with elements uniformly sampled from `arrayToSampleFrom`. Returns nil for an empty array or `sampleLength` <= 0.
*/


public func samplingWithReplacementFromArray<T>(arrayToSampleFrom: [T], #sampleLength: Int) -> [T]? {
    
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

:returns: Array of first `sampleLength` elements from shuffled array. Returns nil for an empty array or if `sampleLength` <= 0 or `sampleLength` > `arrayToSampleFrom.count`.
*/

public func samplingWithoutReplacementFromArray<T>(var arrayToSampleFrom: [T], #sampleLength: Int) -> [T]? {
    
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

/**
Generates random sample from given array using probabilites given by the user.

:param: arrayToSampleFrom The array of any type.
:param: probabilities The array of probabilities.
:param: sampleLength The length of output sample.

:returns: Array of length `sampleLength` with elements sampled from `arrayToSampleFrom` with probabilites from `probabilities`. Returns nil if:

- one of arrays is empty,
- lengths of `arrayToSampleFrom` and `probabilities` are not the same,
- `sampleLength` <= 0,
- `probabilities` does not sum to 1.
*/



public func samplingWithGivenProbabilities<T>(arrayToSampleFrom: [T], #probabilities: [Double], #sampleLength: Int) -> [T]? {
    
    if arrayToSampleFrom.isEmpty || probabilities.isEmpty || arrayToSampleFrom.count != probabilities.count ||
        sampleLength <= 0 {
            
            return nil
    }
    
    //check if array of probabilities sums to 1
    if abs(probabilities.reduce(0, combine: +) - 1.0) > 0.0000001 {
        return nil
    }
    
    var randomSample: [T] = []
    
    for i in 0..<sampleLength {
        
        var sumOfProbabilities = probabilities[0]
        var k = 0
        
        let r = randomContinuousUniform(min: 0.0, max: 1.0)!
        
        while r > sumOfProbabilities {
            k++
            sumOfProbabilities += probabilities[k]
        }
        randomSample.append(arrayToSampleFrom[k])
    }
    
    return randomSample
}




















