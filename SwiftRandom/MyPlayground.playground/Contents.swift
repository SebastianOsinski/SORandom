//: Playground - noun: a place where people can play

import UIKit
import SwiftRandom

let test = SwiftRandom.randomDiscreteUniformArray(min: 0, max: 10, length: 100)

let coin = SwiftRandom.randomBernoulliTrial(probabilityOfSuccess: 0.5)