import SwiftUI

// MARK: - ErrorHandler

@MainActor
protocol ErrorHandler {
    @MainActor
    func handle<T: View>(
        _ error: Binding<BackendError?>,
        in view: T,
        retryHandler: @Sendable @escaping () async -> Void
    ) -> AnyView
}

// MARK: - AlertErrorHandler

@MainActor
struct AlertErrorHandler: ErrorHandler {

    // MARK: - Private Methods

    private let id = UUID()

    // MARK: - Internal Methods

    func handle<T: View>(
        _ error: Binding<BackendError?>,
        in view: T,
        retryHandler: @Sendable @escaping () async -> Void
    ) -> AnyView {
        var isPresented = error.wrappedValue != nil

        let binding = Binding(get: { isPresented }, set: { isPresented = $0 })
        return AnyView(
            view.alert(
                error.wrappedValue?.errorTitle ?? "Error",
                isPresented: binding,
                presenting: error.wrappedValue,
                actions: { _ in
                    makeAlertAction(for: error, retryHandler: retryHandler)
                },
                message: { error in
                    Text(error.errorMessage)
                }
            ).id(id)
        )
    }

    @ViewBuilder
    func makeAlertAction(
        for error: Binding<BackendError?>,
        retryHandler: @Sendable @escaping () async -> Void
    ) -> some View {
        if let wrappedError = error.wrappedValue {
            switch wrappedError.category {
            case .retryable:
                Button("Dismiss") { error.wrappedValue = nil }
                Button("Retry") {
                    error.wrappedValue = nil
                    Task.detached(priority: .background) { await retryHandler() }
                }
            case .nonRetryable:
                Button("Dismiss") {
                    error.wrappedValue = nil
                }
            }
        } else {
            Button("Dismiss") {
                error.wrappedValue = nil
            }
        }
    }
}

// MARK: - ErrorCategory

private enum ErrorCategory {
    case nonRetryable
    case retryable
}

// MARK: - BackendError (ErrorCategory)

private extension BackendError {
    var category: ErrorCategory {
        switch self {
        case .sadServer, .noData, .invalidHTTPStatusCode, .badNetwork, .urlError:
            return .retryable
        case .inlineError(_):
            return .nonRetryable
        }
    }
}
