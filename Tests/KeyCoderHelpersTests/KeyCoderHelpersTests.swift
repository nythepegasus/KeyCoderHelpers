import Foundation
import Testing
@testable import KeyCoderHelpers

enum SharedKeys: CodingKey { case id, name, author }

struct Note: Codable {
    let id: String
    let name: String

    init(_ i: String, _ n: String) { (id, name) = (i, n) }
    
    public init(from decoder: any Decoder) throws {
        self = try decoder.decode { try .init($0.decode(SharedKeys.id), $0.decode(.name)) }
        /*
        // this type is very simple, however the helper makes wrangling data much less cumbersome
        // for example, imagine we just want an empty String instead of a possible Optional
        self = try decoder.decode { try .init($0.decode(.id), $0.decodeIfPresent(.name) ?? "") }
        */
    }

    public func encode(to encoder: any Encoder) throws {
        try encoder.encode { try $0.encode(id, SharedKeys.id); try $0.encode(name, .name) }
        /*
        // similarly here if our data was more complexly shaped the helpers aid with encoding
        // for example, imagine our id was the key into a nested object
        try encoder.encode(name, AnyKey(id), SharedKeys.name)
        */
    }
}

// example of custom layout
// parses {"id":...,"name":...,"author":...}
struct Post: Codable {
    let author: String
    let note: Note

    init(_ a: String, _ n: Note) { (author, note) = (a, n) }

    public init(from decoder: any Decoder) throws {
        (author, note) = try (decoder.decode(SharedKeys.author), decoder.decode())
    }

    public func encode(to encoder: any Encoder) throws {
        try note.encode(to: encoder)
        try encoder.encode(author, "author" as AnyKey)
    }
}

/*
// what the full implementation for each would look like without helpers

enum SharedKeys: CodingKey { case id, name, author }

struct Note: Codable {
    let id: String
    let note: String

    public init(_ i: String, _ n: String) { (id, name) = (i, n) }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: SharedKeys.self)
        id = try container.decode(String.self, forKey: .id)
        note = try container.decode(String.self, forKey: .note)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: SharedKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(note, forKey: .note)
    }
}

struct Post: Codable {
    let author: String
    let note: Note

    public init(_ a: String, _ n: Note) { (author, note) = (a, n) }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: SharedKeys.self)
        author = try container.decode(String.self, forKey: .author)
        note = try Note(from: decoder)
    }

    public func encode(to encoder: any Encoder) throws {
        try note.encode(to: encoder)
        var container = encoder.container(keyedBy: SharedKeys.self)
        try container.encode(author, forKey: .author)
    }
} 
*/

@Test func example() async throws {
    let dec = JSONDecoder()
    let data = #"{"id": "84", "name": "buh", "author": "ny"}"#.data(using: .utf8)!
    let note = try dec.decode(Note.self, from: data)
    let post = try dec.decode(Post.self, from: data)
    #expect(note.id == post.note.id)
    #expect(note.name == post.note.name)
    #expect(post.author == "ny")
}
