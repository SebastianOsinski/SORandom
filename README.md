#SwiftRandom

SwiftRandom is collection of pseudorandom generators from various statistical distributions and functions for pseudorandom array sampling.

##Available psuedorandom generators:

* ####Discrete distributions:
	* Discrete uniform distribution
	* Binomial distribution
* ####Continuous distributions:
	* Continuous uniform distribution
	* Exponential distribution
	* Normal (Gaussian) distribution

##Sampling functions:

* Sampling with replacement
* Sampling without replacement
* Sampling with replacement with given probabilities		 	

##How to use it?

```swift
//Single pseudorandom normal variable with mean 0 and standard deviation 1

let x = SwiftRandom.randomNormal(mean: 0, standardDeviation: 1)!

//Array of pseudorandom independent normal variables with mean 0 and standard deviation 1 and length 10

let sample = SwiftRandom.randomNormalArray(mean: 0, standardDeviation: 1, sampleLength: 10)!


//Sampling from array:

//with replacement

let numbers = [10, 11, 45, 1, 0, 4]

let bootstrapSample = SwiftRandom.samplingWithReplacementFromArray(numbers, sampleLength: 10)

//without replacement

let names = ["John", "Bob", "Anna", "Alice", "Chris", "Luke"]

let usersOrder = SwiftRandom.samplingWithoutReplacementFromArray(names, sampleLength: 4)!
```