import Foundation

extension Task where Success == Never, Failure == Never {
    static func sleep(s: TimeInterval) async throws {
        try await sleep(nanoseconds: UInt64(s * Double(NSEC_PER_SEC)))
    }
}
