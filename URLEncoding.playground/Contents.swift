import Foundation

extension String {
    func addingPrecetEncoding() -> String {
        return self.addingPrecetEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
}

func encodeParametersInUrl(_ parameters: [String: Any]) -> String {
    var components = [(String, String)]()
    
    let sortedKeys = parameters.keys.sorted(by: { $0 < $1})
    
    for key in sortedKeys {
        let value = parameters[key]!
        let queryComponent = queryComponentsWith(key: key, value: value)
        components.append(contentsOf: queryComponent)
    }
    
    let encodedComponents = components.map{ "\($0)=\($1)" }
    return encodedComponents.joined(separator: "&")
}

func queryComponentsWith(key: String, value: Any) -> [(String, String)] {
    var components = [(String, String)]()
    
    if let dictionary = value as? [String: Any] {
        for (nestedKey, value) in dictionary {
            let nestedComponents = queryComponentsWith(key: "\(key)[\(nestedKey)]", value: value)
            components.append(contentsOf: nestedComponents)
        }
    } else if let array = value as? [Any] {
        for value in array {
           let nestedComponents = queryComponentsWith(key: "\(key)[]", value: value)
           components.append(contentsOf: nestedComponents)
        }
    } else {
        let encodedKey = key.addingPrecetEncoding()
        let encodedValue = "\(value)".addingPrecetEncoding()
        
        let component = (encodedKey, encodedValue)
        components.append(component)
    }
    
    return components
}

let peremeters = ["foo": true]
encodeParametersInUrl(peremeters)

let peremters2 =  ["foo": "bar", "baz": "que"]
encodeParametersInUrl(peremters2)

let peremters3 =  ["foo": "<>test123", "baz": "#2"]
encodeParametersInUrl(peremters3)

let peremters4 =  ["foo": ["bar" : 1]]
encodeParametersInUrl(peremters4)

let peremters5 =  ["a": ["bar", 1, true]]
encodeParametersInUrl(peremters5)

























