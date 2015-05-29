//: Playground - noun: a place where people can play

import UIKit
import SwiftRandom

let test = SwiftRandom.randomDiscreteUniformArray(min: 0, max: 10, length: 100)

let coin = SwiftRandom.randomBernoulliTrial(probabilityOfSuccess: 0.5)


let names = ["John", "Bob", "Anna", "Alice", "Chris", "Luke"]
let numbers = [10,11,45,1]

SwiftRandom.samplingWithReplacementFromArray(names, sampleLength: 10)
SwiftRandom.samplingWithReplacementFromArray(numbers, sampleLength: 10)

SwiftRandom.samplingWithoutReplacementFromArray(names, sampleLength: 6)
SwiftRandom.samplingWithoutReplacementFromArray(numbers, sampleLength: 3)
