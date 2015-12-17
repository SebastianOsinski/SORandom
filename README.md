#SORandom

[![Version](https://img.shields.io/cocoapods/v/SORandom.svg?style=flat)](http://cocoapods.org/pods/SORandom)
[![License](https://img.shields.io/cocoapods/l/SORandom.svg?style=flat)](http://cocoapods.org/pods/SORandom)
[![Platform](https://img.shields.io/cocoapods/p/SORandom.svg?style=flat)](http://cocoapods.org/pods/SORandom)

SORandom is collection of pseudorandom generators from various statistical distributions and functions for pseudorandom array sampling.

## Installation

SORandom is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SORandom"
```

## Author

Sebastian Osiński, seb.osinski@gmail.com

## License

SORandom is available under the MIT license. See the LICENSE file for more info.

##Available psuedorandom generators:

* Discrete distributions:
	* [Discrete uniform distribution](https://en.wikipedia.org/wiki/Uniform_distribution_\(discrete\))
	* [Binomial distribution](https://en.wikipedia.org/wiki/Binomial_distribution)
	* [Geometric distribution](https://en.wikipedia.org/?title=Geometric_distribution)
	* [Poisson distribution](https://en.wikipedia.org/?title=Poisson_distribution)
* Continuous distributions:
	* [Continuous uniform distribution](https://en.wikipedia.org/wiki/Uniform_distribution_\(continuous\))
	* [Exponential distribution](https://en.wikipedia.org/?title=Exponential_distribution)
	* [Gamma distribution](https://en.wikipedia.org/wiki/Gamma_distribution)
	* [Beta distribution](https://en.wikipedia.org/wiki/Beta_distribution)
	* [Normal (Gaussian) distribution](https://en.wikipedia.org/wiki/Normal_distribution)
	* [Stable distribution](https://en.wikipedia.org/wiki/Stable_distribution)
	* [Log-normal distribution](https://en.wikipedia.org/wiki/Log-normal_distribution)
	* [Pareto distribution](https://en.wikipedia.org/?title=Pareto_distribution)
	* [Weibull distribution](https://en.wikipedia.org/?title=Weibull_distribution)

##Sampling functions:

* Sampling with replacement
* Sampling without replacement
* Sampling with replacement with given weights		 	

##How to use it?

```swift
import SORandom

//Single pseudorandom normal variable
//with mean 0 and standard deviation 1
let x = randNormal(0, 1)

//Array of pseudorandom independent normal variables
//with mean 0 and standard deviation 1 and length 10
let sample = randNormals(0, 1, 10)

//Sampling from array:

//with replacement
let numbers = [10, 11, 45, 1, 0, 4]
let bootstrapSample = sampleWithReplacement(numbers, 10)

//without replacement
let names = ["John", "Bob", "Anna", "Alice", "Chris", "Luke"]
let usersOrder = sampleWithoutReplacement(names, 4)

//with given weights
let letters = ["a", "b", "c", "d", "e"]
let probabilities = [0.5, 0.05, 0.05, 0.1, 0.3]

let randomLetters = sampleWithWeights(letters, probabilities, 10)
```
