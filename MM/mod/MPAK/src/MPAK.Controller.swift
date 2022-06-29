import Combine

extension MPAK {
  open class Controller<Model> {
    public let m: CurrentValueSubject<Model, Never>

    private var debugClassName: String?
    private var debugLog: ((String) -> Void)?
    private var model: Model
    private var subscriptions = [AnyCancellable]()

    public init(
      _ model: Model,
      debugClassName: String? = nil,
      debugLog: ((String) -> Void)? = nil
    ) {
      m = .init(model)
      self.model = model
      self.debugClassName = debugClassName
      self.debugLog = debugLog
    }

    public func pipe<T>(
      dbg: String? = nil,
      _ node: AnyPublisher<T, Never>,
      _ reaction1: @escaping (inout Model) -> Void,
      _ reaction2: ((inout Model) -> Void)? = nil
    ) {
      node
        .sink { [weak self] _ in
          assert(Thread.isMainThread)
          guard let self = self else { return }
          self.dbgLog(dbg)
          reaction1(&self.model)
          self.m.send(self.model)
          if let reaction = reaction2 {
            reaction(&self.model)
            self.m.send(self.model)
          }
        }
        .store(in: &subscriptions)
    }

    public func pipeOptional<T>(
      dbg: String? = nil,
      _ node: AnyPublisher<T?, Never>,
      _ reaction1: @escaping (inout Model, T?) -> Void,
      _ reaction2: ((inout Model, T?) -> Void)? = nil
    ) {
      node
        .sink { [weak self] value in
          assert(Thread.isMainThread)
          guard let self = self else { return }
          self.dbgLog(dbg)
          reaction1(&self.model, value)
          self.m.send(self.model)
          if let reaction = reaction2 {
            reaction(&self.model, value)
            self.m.send(self.model)
          }
        }
        .store(in: &subscriptions)
    }

    public func pipeValue<T>(
      dbg: String? = nil,
      _ node: AnyPublisher<T, Never>,
      _ reaction1: @escaping (inout Model, T) -> Void,
      _ reaction2: ((inout Model, T) -> Void)? = nil
    ) {
      node
        .sink { [weak self] value in
          assert(Thread.isMainThread)
          guard let self = self else { return }
          self.dbgLog(dbg)
          reaction1(&self.model, value)
          self.m.send(self.model)
          if let reaction = reaction2 {
            reaction(&self.model, value)
            self.m.send(self.model)
          }
        }
        .store(in: &subscriptions)
    }

    private func dbgLog(_ text: String?) {
      guard
        let className = debugClassName,
        let log = debugLog,
        let text = text
      else {
        return
      }
      log("\(className).\(text)")
    }
  }
}
