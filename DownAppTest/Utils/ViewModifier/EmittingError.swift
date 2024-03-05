import SwiftUI

// MARK: - ErrorHandlerEnvironmentKey

@MainActor
struct ErrorHandlerEnvironmentKey: EnvironmentKey {

    // MARK: - Internal properties

    @MainActor
    static let defaultValue: ErrorHandler = AlertErrorHandler()
}

// MARK: - EnvironmentValues (errorHandler)

extension EnvironmentValues {

    // MARK: - Internal properties

    var errorHandler: ErrorHandler {
        get { self[ErrorHandlerEnvironmentKey.self] }
        set { self[ErrorHandlerEnvironmentKey.self] = newValue }
    }
}

// MARK: - View (emittingError)

extension View {
    @MainActor
    func emittingError(
        _ error: Binding<BackendError?>,
        retryHandler: @MainActor @Sendable @escaping () async -> Void = { }
    ) -> some View {
        modifier(ErrorEmittingViewModifier(
            error: error,
            retryHandler: retryHandler
        ))
    }
}

// MARK: - ErrorEmittingViewModifier

@MainActor
struct ErrorEmittingViewModifier: ViewModifier {

    // MARK: - Private properties

    @Environment(\.errorHandler) private var handler

    // MARK: - Internal properties

    @Binding var error: BackendError?
    var retryHandler: @Sendable () async -> Void

    // MARK: - Inerntal methods

    func body(content: Content) -> some View {
        handler.handle(
            $error,
            in: content,
            retryHandler: retryHandler
        )
    }
}
