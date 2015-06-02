import Foundation

///  Collection of psuedorandom generators from various statistical distributions.


// MARK: - Binomial distribution

/**
Performs single Bernoulli trial with given probability of success.
    
:param: probabilityOfSuccess Probability of success.
    
:returns: Success or failure as Int: 1 or 0.
*/
    
public func bernoulliTrial(probabilityOfSuccess: Double) -> Int {
    return Int(randContUniform(0.0, 1.0) < probabilityOfSuccess)
}

/**
Performs series of independent Bernoulli trials with given probability of success.

:param: probabilityOfSuccess Probability of success.
:param: sampleLength Length of sample to generate.

:returns: Array of 1 and 0, which indicate successes and failures.
*/

public func randBinomials(probabilityOfSuccess: Double, sampleLength: Int) -> [Int] {
    return [Int](0..<sampleLength).map { _ in bernoulliTrial(probabilityOfSuccess) }
}

/**
Simulates symmetric coin tossing experiment.

:param: sampleLength Length of sample to generate.

:returns: Array of 1 and 0, which indicate heads and tails.
*/

public func coinTosses(sampleLength: Int) -> [Int] {
    return randBinomials(0.5, sampleLength)
}

// MARK: - Discrete uniform distribution

/**
Generates single pseudorandom variable from discrete uniform distribution.

:param: min Left boundary (inclusive) of distribution.
:param: max Right boundary (inclusive) of distribution. Should be >= `min`.


:returns: Single pseudorandom variable from discrete uniform distribution with given boundaries.
*/

public func randDiscUniform(min: Int, max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max - min + 1))) + min
}

/**
Generates array of independent pseudorandom variables from discrete uniform distribution.

:param: min Left boundary (inclusive) of distribution.
:param: max Right boundary (inclusive) of distribution. Should be >= `min`.
:param: sampleLength Length of sample to generate.

:returns: Array of independent pseudorandom variables from discrete uniform distribution with given boundaries.
*/

public func randDiscUniforms(min: Int, max: Int, sampleLength: Int) -> [Int] {
    return [Int](0..<sampleLength).map { _ in randDiscUniform(min, max) }
}

// MARK: - Continuous uniform distribution

/**
Generates single pseudorandom variable from continuous uniform distribution.

:param: min Left boundary of distribution.
:param: max Right boundary of distribution. Should be >= `min`.

:returns: Single pseudorandom variable from continuous uniform distribution with given boundaries.
*/

public func randContUniform(min: Double, max: Double) -> Double {
    return (max - min) * Double(Double(arc4random()) / Double(UINT32_MAX)) + min
}

/**
Generates array of independent pseudorandom variables from continuous uniform distribution.

:param: min Left boundary of distribution.
:param: max Right boundary of distribution. Should be >= `min`.
:param: sampleLength Length of sample to generate.

:returns: Array of independent pseudorandom variables from continuous uniform distribution with given boundaries. 
*/

public func randContUniforms(min: Double, max: Double, sampleLength: Int) -> [Double] {
    return [Int](0..<sampleLength).map { _ in randContUniform(min, max) }
}

// MARK: - Exponential distribution

/**
Generates single pseudorandom variable from exponential distribution.
Function uses inverse transform sampling.

:param: rate Rate parameter of exponential distribution. Should be > 0.

:returns: Single pseudorandom variable from exponential distribution with given rate.
*/

public func randExp(rate: Double) -> Double {
    return -1.0/rate * log(randContUniform(0, 1))
}

/**
Generates array of independent pseudorandom variables from exponential distribution.
Function uses inverse transform sampling.

:param: rate Rate parameter of exponential distribution. Should be > 0.
:param: sampleLength Length of sample to generate.

:returns: Array of independent pseudorandom variables from exponential distribution with given rate.
*/

public func randExps(rate: Double, sampleLength: Int) -> [Double] {
    return [Int](0..<sampleLength).map { _ in randExp(rate) }
}

// MARK: - Normal distribution

/**
Generates single pseudorandom variable from normal distribution.
Function uses Box-Muller transform.

:param: mean Mean of normal distribution.
:param: standardDeviation Standard deviation of normal distribution.

:returns: Single pseudorandom variable from normal distribution with given mean and standard deviation.
*/

// TODO: Refactor
public func randNormal(mean: Double, standardDeviation: Double) -> Double {
    
    let u = randContUniforms(0, 1, 2)
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

:returns: Array of independent pseudorandom variables from normal distribution with given mean and standard deviation. 
*/

// TODO: Refactor
public func randNormals(mean: Double, standardDeviation: Double, sampleLength: Int) -> [Double] {
    
    let numberOfPairs: Int = sampleLength/2
    let u1 = randContUniforms(0, 1, numberOfPairs)
    let u2 = randContUniforms(0, 1, numberOfPairs)
    
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
        randomSample[sampleLength - 1] = randNormal(mean, standardDeviation)
    }
    
    return randomSample
}

// MARK: - Sampling

/**
Generates random sample from given array - sampling with replacement.

:param: arrayToSampleFrom The array of any type.
:param: sampleLength The length of output sample.

:returns: Array of length `sampleLength` with elements uniformly sampled from `arrayToSampleFrom`.
*/

// TODO: Refactor
public func sampleWithReplacement<T>(arrayToSampleFrom: [T], sampleLength: Int) -> [T] {
    
    let inputArrayLength = arrayToSampleFrom.count
    var randomSample: [T] = []
    
    for i in 1...sampleLength {
        randomSample.append(arrayToSampleFrom[randDiscUniform(0, inputArrayLength - 1)])
    }
    
    return randomSample
}

/**
Generates random sample from given array - sampling without replacement.
Function uses Fisher-Yates shuffling algorithm and returns Array of first `sampleLength` elements.

:param: arrayToSampleFrom The array of any type.
:param: sampleLength The length of output sample.

:returns: Array of first `sampleLength` elements from shuffled array. 
*/

// TODO: Refactor
public func sampleWithoutReplacement<T>(var arrayToSampleFrom: [T], sampleLength: Int) -> [T] {
    
    let inputArrayLength = arrayToSampleFrom.count
    
    for i in 0..<(inputArrayLength - 1) {
        let k = randDiscUniform(i, inputArrayLength - 1)
        swap(&arrayToSampleFrom[i], &arrayToSampleFrom[k])
    }
    
    return Array(arrayToSampleFrom[0..<sampleLength])
}

/**
Generates random sample from given array using probabilites given by the user.

:param: arrayToSampleFrom The array of any type.
:param: probabilities The array of probabilities.
:param: sampleLength The length of output sample.

:returns: Array of length `sampleLength` with elements sampled from `arrayToSampleFrom` with probabilites from `probabilities`. 

*/

// TODO: Refactor
public func sampleWithProbs<T>(arrayToSampleFrom: [T], probabilities: [Double], sampleLength: Int) -> [T] {
    
    var randomSample: [T] = []
    
    for i in 0..<sampleLength {
        
        var sumOfProbabilities = probabilities[0]
        var k = 0
        
        let r = randContUniform(0.0, 1.0)
        
        while r > sumOfProbabilities {
            k++
            sumOfProbabilities += probabilities[k]
        }
        randomSample.append(arrayToSampleFrom[k])
    }
    
    return randomSample
}




















