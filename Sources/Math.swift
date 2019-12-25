// Copyright © 2019 ChouTi. All rights reserved.

import Foundation

/// Linearly interpolates between start and end by t. The parameter t is clamped to the range [0, 1].
/// When t = 0 returns start.
/// When t = 1 return end.
/// When t = 0.5 returns the midpoint of start and end.
///
/// - Parameters:
///   - start: The start value.
///   - end: The end value.
///   - t: The interpolation value between the two floats.
/// - Returns: The interpolated float result between the two float values.
public func lerp<T: BinaryFloatingPoint>(start: T, end: T, t: T) -> T {
  return start + (end - start) * t.clamped(to: 0.0...1.0)
}
