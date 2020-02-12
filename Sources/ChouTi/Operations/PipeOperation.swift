// Copyright © 2020 ChouTi. All rights reserved.

import Foundation

// MARK: - Types

protocol OutputTaskType {
  associatedtype Output
  var output: Output { get }
}

// MARK: - Sync

/// A task that only generates an output.
/// ... -> output
class OutputTask<Output>: Operation, OutputTaskType {
  /// The output. Before finishing, it's the default value.
  var output: Output

  /// The block provides an output.
  private let block: () -> Output

  /// Init an output only task.
  /// - Parameter block: A block provides an output.
  init(defaultOutput: Output, block: @escaping (() -> Output)) {
    self.output = defaultOutput
    self.block = block
    super.init()
  }

  override func main() {
    output = block()
  }
}

/// A task that can consume an input and generates an output.
/// input -> ... -> output
class PipeTask<Input, Output, DependencyTask: OutputTaskType>: Operation, OutputTaskType where DependencyTask.Output == Input {
  /// The dependency task that provides an input for this task.
  let dependencyTask: DependencyTask

  /// The output. Before finishing, it's the default value.
  var output: Output

  /// The block which consumes an input and provides an output.
  private let block: (Input) -> Output

  /// Init a pipe task.
  /// - Parameters:
  ///   - dependencyTask: The dependency task that provides an input.
  ///   - defaultOutput: A default output value before finishing.
  ///   - block: A block which consumes an input and provides an output.
  init(dependencyTask: DependencyTask, defaultOutput: Output, block: @escaping ((Input) -> Output)) {
    self.dependencyTask = dependencyTask
    self.output = defaultOutput
    self.block = block
    super.init()
  }

  override func main() {
    output = block(dependencyTask.output)
  }
}

/// A task that consumes an input.
/// input -> ...
class InputTask<Input, DependencyTask: OutputTaskType>: Operation where DependencyTask.Output == Input {
  typealias Finish = () -> Void

  /// The dependency task that provides an input for this task.
  let dependencyTask: DependencyTask

  /// The block which consumes an input.
  private let block: (Input) -> Void

  /// Init an input only task.
  /// - Parameters:
  ///   - dependencyTask: The dependency task that provides an input.
  ///   - block: A block which consumes an input.
  init(dependencyTask: DependencyTask, block: @escaping (Input) -> Void) {
    self.dependencyTask = dependencyTask
    self.block = block
  }

  override func main() {
    block(dependencyTask.output)
  }
}

// MARK: - Async

/// An async task that only generates an output.
/// ... -> output
class AsyncOutputTask<Output>: AsyncOperation, OutputTaskType {
  typealias Finish = (Output) -> Void

  /// The output. Before finishing, it's the default value.
  var output: Output

  /// The block provides a finish callback block. Should call finish with an output.
  private let block: (@escaping Finish) -> Void

  /// Init an output only task.
  /// - Parameter block: The block which provides a finish callback block to call when job is finished. Should call the finish with an output.
  init(defaultOutput: Output, block: @escaping (@escaping Finish) -> Void) {
    self.output = defaultOutput
    self.block = block
    super.init()
  }

  override func main() {
    block { [weak self] output in
      self?.output = output
      self?.finish()
    }
  }
}

/// An async task that can consume an input and generates an output.
/// input -> ... -> output
class AsyncPipeOperation<Input, Output, DependencyTask: OutputTaskType>: AsyncOperation, OutputTaskType where DependencyTask.Output == Input {
  typealias Finish = (Output) -> Void

  /// The dependency task that provides an input for this task.
  let dependencyTask: DependencyTask

  /// The output. Before finishing, it's the default value.
  var output: Output

  /// The block which consumes an input and provides the finish callback block.
  private let block: (Input, @escaping Finish) -> Void

  /// Init an input -> output task.
  /// - Parameters:
  ///   - dependencyTask: The dependency task that provides an input.
  ///   - defaultOutput: The default output value.
  ///   - block: The block which consumes an input and provides the finish callback block. Should call the finish with an output.
  init(dependencyTask: DependencyTask, defaultOutput: Output, block: @escaping (Input, @escaping Finish) -> Void) {
    self.dependencyTask = dependencyTask
    self.output = defaultOutput
    self.block = block
    super.init()
  }

  override func main() {
    block(dependencyTask.output) { [weak self] output in
      self?.output = output
      self?.finish()
    }
  }
}

/// An async task that consumes an input.
/// input -> ...
class AsyncInputTask<Input, DependencyTask: OutputTaskType>: AsyncOperation where DependencyTask.Output == Input {
  typealias Finish = () -> Void

  /// The dependency task that provides an input for this task.
  let dependencyTask: DependencyTask

  private let block: (Input, @escaping Finish) -> Void

  /// Init an input only task.
  /// - Parameters:
  ///   - dependencyTask: The dependency task that provides an input.
  ///   - block: The block which consumes an input and provides the finish callback block. Should call the finish with an output.
  init(dependencyTask: DependencyTask, block: @escaping (Input, @escaping Finish) -> Void) {
    self.dependencyTask = dependencyTask
    self.block = block
  }

  override func main() {
    block(dependencyTask.output, finish)
  }
}
