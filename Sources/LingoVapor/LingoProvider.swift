import Vapor
import Lingo

extension Application {
    public var lingoVapor: LingoProvider {
        .init(application: self)
    }
}

public struct LingoProvider {
    let application: Application
    
    public init(application: Application) {
        self.application = application
    }
    
    public func lingo() throws -> Lingo {
        let rootPath: String
        if let localizationsDir = configuration?.localizationsDir, localizationsDir.contains("/") {
            rootPath = localizationsDir
        } else {
            let directory = application.directory.workingDirectory
            let workDir = directory.hasSuffix("/") ? directory : directory + "/"
            rootPath = workDir + (configuration?.localizationsDir ?? "")
        }
        return try Lingo(rootPath: rootPath, defaultLocale: (configuration?.defaultLocale ?? ""))
    }
}

extension LingoProvider {
    struct ConfigurationKey: StorageKey {
        typealias Value = LingoConfiguration
    }
    
    public var configuration: LingoConfiguration? {
        get { application.storage[ConfigurationKey.self] }
        nonmutating set { application.storage[ConfigurationKey.self] = newValue }
    }
}

public struct LingoConfiguration {
    let defaultLocale, localizationsDir: String
    
    public init(defaultLocale: String, localizationsDir: String = "Localizations") {
        self.defaultLocale = defaultLocale
        self.localizationsDir = localizationsDir
    }
}


