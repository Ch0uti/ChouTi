// Copyright © 2020 ChouTi. All rights reserved.

import Foundation

// MARK: - Types

public protocol OutputTaskType {
  associatedtype Output
  var output: Output { get }
}

// MARK: - Sync

/// A task that only generates an output.
/// ... -> output
public class OutputTask<Output>: Operation, OutputTaskType {
  /// The output. Before finishing, it's the default value.
  public var output: Output

  /// The block provides an output.
  private let block: () -> Output

  /// Init an output only task.
  /// - Parameter block: A block provides an output.
  public init(defaultOutput: Output, block: @escaping (() -> Output)) {
    self.output = defaultOutput
    self.block = block
    super.init()
  }

  public override func main() {
    output = block()
  }
}

/// A task that can consume an input and generates an output.
/// input -> ... -> output
public class PipeTask<Input, Output, DependencyTask: OutputTaskType>: Operation, OutputTaskType where DependencyTask.Output == Input {
  /// The dependency task that provides an input for this task.
  public let dependencyTask: DependencyTask

  /// The output. Before finishing, it's the default value.
  public var output: Output

  /// The block which consumes an input and provides an output.
  private let block: (Input) -> Output

  /// Init a pipe task.
  /// - Parameters:
  ///   - dependencyTask: The dependency task that provides an input.
  ///   - defaultOutput: A default output value before finishing.
  ///   - block: A block which consumes an input and provides an output.
  public init(dependencyTask: DependencyTask, defaultOutput: Output, block: @escaping ((Input) -> Output)) {
    self.dependencyTask = dependencyTask
    self.output = defaultOutput
    self.block = block
    super.init()
  }

  public override func main() {
    output = block(dependencyTask.output)
  }
}

/// A task that consumes an input.
/// input -> ...
public class InputTask<Input, DependencyTask: OutputTaskType>: Operation where DependencyTask.Output == Input {
  typealias Finish = () -> Void

  /// The dependency task that provides an input for this task.
  public let dependencyTask: DependencyTask

  /// The block which consumes an input.
  private let block: (Input) -> Void

  /// Init an input only task.
  /// - Parameters:
  ///   - dependencyTask: The dependency task that provides an input.
  ///   - block: A block which consumes an input.
  public init(dependencyTask: DependencyTask, block: @escaping (Input) -> Void) {
    self.dependencyTask = dependencyTask
    self.block = block
  }

  public override func main() {
    block(dependencyTask.output)
  }
}

// MARK: - Async

/// An async task that only generates an output.
/// ... -> output
public class AsyncOutputTask<Output>: AsyncOperation, OutputTaskType {
  public typealias Finish = (Output) -> Void

  /// The output. Before finishing, it's the default value.
  public var output: Output

  /// The block provides a finish callback block. Should call finish with an output.
  private let block: (@escaping Finish) -> Void

  /// Init an output only task.
  /// - Parameter block: The block which provides a finish callback block to call when job is finished. Should call the finish with an output.
  public init(defaultOutput: Output, block: @escaping (@escaping Finish) -> Void) {
    self.output = defaultOutput
    self.block = block
    super.init()
  }

  public override func main() {
    block { [weak self] output in
      self?.output = output
      self?.finish()
    }
  }
}

/// An async task that can consume an input and generates an output.
/// input -> ... -> output
public class AsyncPipeOperation<Input, Output, DependencyTask: OutputTaskType>: AsyncOperation, OutputTaskType where DependencyTask.Output == Input {
  public typealias Finish = (Output) -> Void

  /// The dependency task that provides an input for this task.
  public let dependencyTask: DependencyTask

  /// The output. Before finishing, it's the default value.
  public var output: Output

  /// The block which consumes an input and provides the finish callback block.
  private let block: (Input, @escaping Finish) -> Void

  /// Init an input -> output task.
  /// - Parameters:
  ///   - dependencyTask: The dependency task that provides an input.
  ///   - defaultOutput: The default output value.
  ///   - block: The block which consumes an input and provides the finish callback block. Should call the finish with an output.
  public init(dependencyTask: DependencyTask, defaultOutput: Output, block: @escaping (Input, @escaping Finish) -> Void) {
    self.dependencyTask = dependencyTask
    self.output = defaultOutput
    self.block = block
    super.init()
  }

	override public func main() {
    block(dependencyTask.output) { [weak self] output in
      self?.output = output
      self?.finish()
    }
  }
}

/// An async task that consumes an input.
/// input -> ...
public class AsyncInputTask<Input, DependencyTask: OutputTaskType>: AsyncOperation where DependencyTask.Output == Input {
  public typealias Finish = () -> Void

  /// The dependency task that provides an input for this task.
  public let dependencyTask: DependencyTask

  private let block: (Input, @escaping Finish) -> Void

  /// Init an input only task.
  /// - Parameters:
  ///   - dependencyTask: The dependency task that provides an input.
  ///   - block: The block which consumes an input and provides the finish callback block. Should call the finish with an output.
  public init(dependencyTask: DependencyTask, block: @escaping (Input, @escaping Finish) -> Void) {
    self.dependencyTask = dependencyTask
    self.block = block
  }

	override public func main() {
    block(dependencyTask.output, finish)
  }
}

extension String: OutputTaskType {
	public var output: Self { self }
}

extension Int: OutputTaskType {
	public var output: Self { self }
}
