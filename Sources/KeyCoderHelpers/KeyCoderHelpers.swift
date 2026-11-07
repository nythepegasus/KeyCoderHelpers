
/// A helper that allows for getting all of a Decoder's keys at runtime.
@frozen
public struct AnyKey: CodingKey, ExpressibleByStringLiteral {
    /// The key's value.
    public let stringValue: String
    /// Required for CodingKey, always nil.
    @_transparent
    public var intValue: Int? { nil }

    @_transparent
    public init?(intValue: Int) { nil }

    @_transparent
    public init(stringLiteral value: StringLiteralType) {
        self.stringValue = value
    }

    @_transparent
    public init?(stringValue: String) {
        self.stringValue = stringValue
    }

    @_transparent
    public init(_ string: String) {
        self.stringValue = string
    }
}

public extension Decoder {
    @_transparent
    var allKeys: [String] {
        get throws { try container(keyedBy: AnyKey.self).allKeys.map(\.stringValue) }
    }

    @_transparent
    func container<K: CodingKey>() throws -> KeyedDecodingContainer<K> {
        try container(keyedBy: K.self)
    }

    @_transparent
    func container<K: CodingKey, C: CodingKey>(_ root: K) throws -> KeyedDecodingContainer<C> {
        try container().nestedContainer(keyedBy: C.self, forKey: root)
    }

    @_transparent
    func contains(_ root: String, _ key: String) throws -> Bool {
        try contains(AnyKey(root), AnyKey(key))
    }

    @_transparent
    func contains<K: CodingKey>(_ root: K, _ key: String) throws -> Bool {
        try contains(root, AnyKey(key))
    }

    @_transparent
    func contains<K: CodingKey>(_ root: String, _ key: K) throws -> Bool {
        try contains(AnyKey(root), key)
    }

    @_transparent
    func contains(_ key: String) throws -> Bool {
        try contains(AnyKey(key))
    }

    @_transparent
    func contains<K: CodingKey, C: CodingKey>(_ root: K, _ key: C) throws -> Bool {
        try container(root).contains(key)
    }

    @_transparent
    func contains<K: CodingKey>(_ root: K, _ key: K) throws -> Bool {
        try container(root).contains(key)
    }

    @_transparent
    func contains<K: CodingKey>(_ key: K) throws -> Bool {
        try container().contains(key)
    }

    @_transparent
    func decode<T: Decodable>() throws -> T {
        try T(from: self)
    }

    @_transparent
    func decode<K: CodingKey, C: CodingKey, T: Decodable>(_ key: K, _: C.Type = C.self, _ with: (KeyedDecodingContainer<C>) throws -> T) throws -> T {
        try with(container(key))
    }

    @_transparent
    func decode<K: CodingKey, C: CodingKey, T: Decodable>(_ root: K, _ key: C) throws -> T {
        try decode(root) { try $0.decode(key) }
    }

    @_transparent
    func decode<K: CodingKey, T: Decodable>(_: K.Type = K.self, _ with: (KeyedDecodingContainer<K>) throws -> T) throws -> T {
        try with(container())
    }

    @_transparent
    func decode<K: CodingKey, T: Decodable>(_ root: K, _ key: K) throws -> T {
        try decode(root) { try $0.decode(key) }
    }

    @_transparent
    func decode<K: CodingKey, T: Decodable>(_ key: K) throws -> T {
        try decode { try $0.decode(key) }
    }

    @_transparent
    func decode<T: Decodable>(_ root: String, _ key: String) throws -> T {
        try decode(AnyKey(root), AnyKey(key))
    }

    @_transparent
    func decode<K: CodingKey, T: Decodable>(_ root: K, _ key: String) throws -> T {
        try decode(root, AnyKey(key))
    }

    @_transparent
    func decode<K: CodingKey, T: Decodable>(_ root: String, _ key: K) throws -> T {
        try decode(AnyKey(root), key)
    }

    @_transparent
    func decode<T: Decodable>(_ key: String) throws -> T {
        try decode(AnyKey(key))
    }

    @_transparent
    func decodeIfPresent<K: CodingKey, C: CodingKey, T: Decodable>(_ key: K, _: C.Type = C.self, _ with: (KeyedDecodingContainer<C>) throws -> T?) throws -> T? {
        try with(container(key))
    }

    @_transparent
    func decodeIfPresent<K: CodingKey, C: CodingKey, T: Decodable>(_ root: K, _ key: C) throws -> T? {
        try decodeIfPresent(root) { try $0.decodeIfPresent(key) }
    }

    @_transparent
    func decodeIfPresent<K: CodingKey, T: Decodable>(_: K.Type = K.self, _ with: (KeyedDecodingContainer<K>) throws -> T?) throws -> T? {
        try with(container())
    }

    @_transparent
    func decodeIfPresent<K: CodingKey, T: Decodable>(_ root: K, _ key: K) throws -> T? {
        try decodeIfPresent(root) { try $0.decodeIfPresent(key) }
    }

    @_transparent
    func decodeIfPresent<K: CodingKey, T: Decodable>(_ key: K) throws -> T? {
        try decodeIfPresent { try $0.decodeIfPresent(key) }
    }

    @_transparent
    func decodeIfPresent<T: Decodable>(_ root: String, _ key: String) throws -> T? {
        try decodeIfPresent(AnyKey(root)) { try $0.decodeIfPresent(AnyKey(key)) }
    }

    @_transparent
    func decodeIfPresent<K: CodingKey, T: Decodable>(_ root: K, _ key: String) throws -> T? {
        try decodeIfPresent(root) { try $0.decodeIfPresent(AnyKey(key)) }
    }

    @_transparent
    func decodeIfPresent<K: CodingKey, T: Decodable>(_ root: String, _ key: K) throws -> T? {
        try decodeIfPresent(AnyKey(root)) { try $0.decodeIfPresent(key) }
    }

    @_transparent
    func decodeIfPresent<T: Decodable>(_ key: String) throws -> T? {
        try decodeIfPresent { try $0.decodeIfPresent(AnyKey(key)) }
    }
}

public extension Encoder {
    @_transparent
    func encode<K: CodingKey, C: CodingKey>(_ key: K, _: C.Type = C.self, _ with: (inout KeyedEncodingContainer<C>) throws -> Void) rethrows {
        var container: KeyedEncodingContainer<K> = container(keyedBy: K.self)
        var nested = container.nestedContainer(keyedBy: C.self, forKey: key)
        try with(&nested)
    }

    @_transparent
    func encode<K: CodingKey>(_: K.Type = K.self, _ with: (inout KeyedEncodingContainer<K>) throws -> Void) rethrows {
        var container: KeyedEncodingContainer<K> = container(keyedBy: K.self)
        try with(&container)
    }

    @_transparent
    func encode<T: Encodable>(_ value: T) throws {
        try value.encode(to: self)
    }

    @_transparent
    func encode<K: CodingKey, C: CodingKey, T: Encodable>(_ value: T, _ root: K, _ key: C) throws {
        try encode(root) { try $0.encode(value, key) }
    }

    @_transparent
    func encode<K: CodingKey, T: Encodable>(_ value: T, _ root: K, _ key: K) throws {
        try encode(root) { try $0.encode(value, key) }
    }

    @_transparent
    func encode<K: CodingKey, T: Encodable>(_ value: T, _ key: K) throws {
        try encode { try $0.encode(value, key) }
    }

    @_transparent
    func encodeIfPresent<K: CodingKey, C: CodingKey, T: Encodable>(_ value: T?, _ root: K, _ key: C) throws {
        try encode(root) { try $0.encodeIfPresent(value, key) }
    }

    @_transparent
    func encodeIfPresent<K: CodingKey, T: Encodable>(_ value: T?, _ root: K, _ key: K) throws {
        try encode(root) { try $0.encodeIfPresent(value, key) }
    }

    @_transparent
    func encodeIfPresent<K: CodingKey, T: Encodable>(_ value: T?, _ key: K) throws {
        try encode { try $0.encodeIfPresent(value, key) }
    }

    @_transparent
    func encode<T: Encodable>(_ value: T, _ root: String, _ key: String) throws {
        try encode(value, AnyKey(root), AnyKey(key))
    }

    @_transparent
    func encode<K: CodingKey, T: Encodable>(_ value: T, _ root: K, _ key: String) throws {
        try encode(value, root, AnyKey(key))
    }

    @_transparent
    func encode<K: CodingKey, T: Encodable>(_ value: T, _ root: String, _ key: K) throws {
        try encode(value, AnyKey(root), key)
    }

    @_transparent
    func encode<T: Encodable>(_ value: T, _ key: String) throws {
        try encode(value, AnyKey(key))
    }

    @_transparent
    func encodeIfPresent<T: Encodable>(_ value: T?, _ root: String, _ key: String) throws {
        try encodeIfPresent(value, AnyKey(root), AnyKey(key))
    }

    @_transparent
    func encodeIfPresent<K: CodingKey, T: Encodable>(_ value: T?, _ root: K, _ key: String) throws {
        try encodeIfPresent(value, root, AnyKey(key))
    }

    @_transparent
    func encodeIfPresent<K: CodingKey, T: Encodable>(_ value: T?, _ root: String, _ key: K) throws {
        try encodeIfPresent(value, AnyKey(root), key)
    }

    @_transparent
    func encodeIfPresent<T: Encodable>(_ value: T?, _ key: String) throws {
        try encodeIfPresent(value, AnyKey(key))
    }
}

public extension KeyedDecodingContainer {
    @_transparent
    func decode<T: Decodable>(_ key: K) throws -> T {
        try decode(T.self, forKey: key)
    }

    @_transparent
    func decodeIfPresent<T: Decodable>(_ key: K) throws -> T? {
        try decodeIfPresent(T.self, forKey: key)
    }
}

public extension KeyedEncodingContainer {
    @_transparent
    mutating func encode<T: Encodable>(_ value: T, _ key: K) throws {
        try encode(value, forKey: key)
    }

    @_transparent
    mutating func encodeIfPresent<T: Encodable>(_ value: T?, _ key: K) throws {
        try encodeIfPresent(value, forKey: key)
    }
}

