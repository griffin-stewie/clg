import Foundation

public enum FixtureError: Error {
    case resourceNotFound
    case readFailed(Error)
    case convertToStringFailed
}

public class Fixture {

    let defaultBuildDir = ".build"

    public init() {}

    public func fileURL(forResource resource: String, ofType type: String) throws -> URL {
        let bundle = Bundle(for: Swift.type(of: self))
        let pathCompos = URL(fileURLWithPath: bundle.bundlePath).pathComponents
        guard let idx = pathCompos.lastIndex(of: defaultBuildDir) else {
            fatalError("To test your code. use 'swift text' from Terminal.")
        }

        // a first path componets is `/`, so we need to drop first elements to re-construct absolute path.
        let pathSubString = Array(pathCompos[0..<idx]).joined(separator: "/").dropFirst()
        guard let root = URL(string: String(pathSubString)) else {
            fatalError("failed")
        }

        let resourceURL = root
            .appendingPathComponent("Fixtures")
            .appendingPathComponent(resource)
            .appendingPathExtension(type)

        guard FileManager.default.fileExists(atPath: resourceURL.path) else {
            throw FixtureError.resourceNotFound
        }

        return URL(fileURLWithPath: resourceURL.path)
    }
}
