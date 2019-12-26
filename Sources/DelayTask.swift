// Copyright © 2019 ChouTi. All rights reserved.

import Foundation

/// Cancelable delayed task
public class DelayTask {
  /// Whether this task is canceled.
  public var isCanceled: Bool = false

  /// Whether this task has been executed.
  public private(set) var isExecuted: Bool = false

  /// Closure to be executed
  private let task: () -> Void

  /// Queue the task will run
  public let queue: DispatchQueue

  /// Delay seconds
  private let delayedSeconds: TimeInterval

  /// Init a DelayTask with delay seconds, queue and task closure
  /// - Parameters:
  ///   - queue: The dispatch queue to run on.
  ///   - delayedSeconds: The delayed seconds.
  ///   - task: The closure to run.
  init(queue: DispatchQueue, delayedSeconds: TimeInterval, task: @escaping () -> Void) {
    self.delayedSeconds = delayedSeconds
    self.queue = queue
    self.task = task
  }

  /// Start the task.
  public func start() {
    // Strongly retains self to make sure the task closure will eventually run.
    queue.asyncAfter(deadline: .now() + delayedSeconds) {
      guard self.isCanceled == false else {
        return
      }

      self.task()
      self.isExecuted = true

      // Dispatch next task if needed
      if let nextTask = self.nextTask {
        nextTask.start()
      }
    }
  }

  /// Next chained task
  private var nextTask: DelayTask?

  /// Chaining a new task.
  /// - Parameters:
  ///   - delayedSeconds: The delayed seconds.
  ///   - queue: The dispatch queue to run on.
  ///   - task: The closure to run.
  @discardableResult
  public func delay(_ delayedSeconds: TimeInterval, queue: DispatchQueue = .global(), task: @escaping () -> Void) -> DelayTask {
    let task = DelayTask(queue: queue, delayedSeconds: delayedSeconds, task: task)
    nextTask = task
    return task
  }
}

/// Execute the task closure on specified queue after delayed seconds.
/// - Parameters:
///   - delayedSeconds: The delayed seconds.
///   - queue: The dispatch queue to run on.
///   - task: The closure to run.
@discardableResult
public func delay(_ delayedSeconds: TimeInterval, queue: DispatchQueue = .global(), task: @escaping () -> Void) -> DelayTask {
  let task = DelayTask(queue: queue, delayedSeconds: delayedSeconds, task: task)
  task.start()
  return task
}
