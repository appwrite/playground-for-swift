import Appwrite
import NIO
import Foundation

let host = "https://demo.appwrite.io/v1"
let projectId = ""
let apiKey = ""

var collectionId = ""
var fileId = ""
var userId = ""
var functionId = ""

let client = Client()
    .setEndpoint(host)
    .setProject(projectId)
    .setKey(apiKey)

let group = DispatchGroup()

func convertToDictionary(text: String) -> [String: Any]? {
    guard let data = text.data(using: .utf8) else {
        return nil
    }
    return try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
}

func main() {
    createCollection()
}

func createCollection() {
    let database = Database(client)
    print("Running create collection API")

    group.enter()
    database.createCollection(
        name: "Movies",
        read: ["*"],
        write: ["*"],
        rules: [[
            "label": "Name",
            "key": "name",
            "type": "text",
            "default": "Empty Name",
            "required": true,
            "array": false
        ], [
            "label":  "release_year",
            "key":  "release_year",
            "type":  "numeric",
            "default":  1970,
            "required":  true,
            "array":  false
        ]],
        completion: { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let collection):
                print(try! JSONSerialization.data(withJSONObject: collection.toMap()))
            }
            group.leave()
        }
    )
    group.wait()
}

func listCollection() {
    let database = Database(client)
    print("Running list collection API")

    group.enter()
    database.listCollections(completion: { result in
        switch result {
        case .failure(let error):
            print(error)
        case .success(let collectionList):
            print(try! JSONSerialization.data(withJSONObject: collectionList.toMap()))
        }
        group.leave()
    })
    group.wait()
}

func deleteCollection() {
    let database = Database(client)
    print("Running delete collection API")

    group.enter()
    database.deleteCollection(collectionId: collectionId, completion: { result in
        switch result {
        case .failure(let error):
            print(error)
        case .success:
            print("collection deleted")
        }
        group.leave()
    })
    group.wait()
}

func addDoc() {
    let database = Database(client)
    print("Running Add Document API")

    group.enter()
    database.createDocument(
        collectionId: collectionId,
        data: [
            "name": "Spider Man",
            "release_year": 1920
        ],
        read: ["*"],
        write: ["*"],
        completion: { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let document):
                print(try! JSONSerialization.data(withJSONObject: document.toMap()))
            }
            group.leave()
        })
    group.wait()
}

func listDoc() {
    let database = Database(client)
    print("Running List Document API")

    group.enter()
    database.listDocuments(collectionId: collectionId, completion: { result in
        switch result {
        case .failure(let error):
            print(error)
        case .success(let documentList):
            print(try! JSONSerialization.data(withJSONObject: documentList.toMap()))
        }
        group.leave()
    })
    group.wait()
}

func uploadFile() {
    let storage = Storage(client)
    print("Running Upload File API")

    guard let data = FileManager.default.contents(atPath: "./nature.png") else {
        return
    }

    let file = File(name: "nature.png", buffer: ByteBuffer(data: data))

    group.enter()
    storage.createFile(
        file: file,
        read: ["*"],
        write: [],
        completion: { result in
        switch result {
        case .failure(let error):
            print(error)
        case .success(let file):
            print(try! JSONSerialization.data(withJSONObject: file.toMap()))
        }
        group.leave()
    })
    group.wait()
}

func deleteFile() {
    let storage = Storage(client)
    print("Running Delete File API")

    group.enter()
    storage.deleteFile(fileId: fileId, completion: { result in
        switch result {
        case .failure(let error):
            print(error)
        case .success:
            print("Success")
        }
        group.leave()
    })
    group.wait()
}

func createFunction() {
    let functions = Functions(client)
    print("Running Create Function API")

    group.enter()
    functions.create(
        name: "test function",
        execute: [],
        runtime: "dart-2.12",
        completion: { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let function):
                print(try! JSONSerialization.data(withJSONObject: function.toMap()))
            }
            group.leave()
        })
    group.wait()
}

func listFunctions() {
    let functions = Functions(client)
    print("Running List Functions API")

    group.enter()
    functions.list(completion: { result in
        switch result {
        case .failure(let error):
            print(error)
        case .success(let functionList):
            print(try! JSONSerialization.data(withJSONObject: functionList.toMap()))
        }
        group.leave()
    })
    group.wait()
}

func deleteFunction() {
    let functions = Functions(client)
    print("Running Delete Function API")

    group.enter()
    functions.delete(functionId: functionId, completion: { result in
        switch result {
        case .failure(let error):
            print(error)
        case .success:
            print("Success")
        }
        group.leave()
    })
    group.wait()
}

func listUsers() {
    print("Running list users API")
    let users = Users(client)

    group.enter()
    users.list(completion: { result in
        switch result {
        case .failure(let error):
            print(error)
        case .success(let userList):
            print(try! JSONSerialization.data(withJSONObject: userList.toMap()))
        }
        group.leave()
    })
    group.wait()
}

func createUser(email: String, password: String, name: String) {
    print("Running create user API")
    let users = Users(client)

    group.enter()
    users.create(
        email: "email@example.com",
        password:"password",
        completion: { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let user):
                print(try! JSONSerialization.data(withJSONObject: user.toMap()))
            }
            group.leave()
        })
    group.wait()
}

func deleteUser() {
    let users = Users(client)
    print("Running delete user API")

    group.enter()
    users.delete(userId: userId, completion: { result in
        switch result {
        case .failure(let error):
            print(error)
        case .success:
            print("Success")
        }
        group.leave()
    })
    group.wait()
}

main()
