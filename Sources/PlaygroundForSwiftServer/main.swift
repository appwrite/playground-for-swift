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
var documentId = ""

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
    
    createUser()
    listUsers()
    deleteUser()
    
    createCollection()
    listCollection()
    defer {
        deleteCollection()
    }
    
    createDocument()
    listDocuments()
    deleteDocument()
    
    createFunction()
    listFunctions()
    deleteFunction()
    
    uploadFile()
    listFiles()
    deleteFile()
}

func createUser() {
    print("Running create user API")
    let users = Users(client)

    group.enter()
    users.create(
        userId: "unique()",
        email: "email@example.com",
        password:"password",
        completion: { result in
            switch result {
            case .failure(let error):
                print(error.message)
            case .success(let user):
                print(try! JSONSerialization.data(withJSONObject: user.toMap()))
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
            print(error.message)
        case .success(let userList):
            print(try! JSONSerialization.data(withJSONObject: userList.toMap()))
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
            print(error.message)
        case .success:
            print("Success")
        }
        group.leave()
    })
    group.wait()
}

func createCollection() {
    let database = Database(client)
    print("Running create collection API")

    group.enter()
    database.createCollection(
        collectionId: "movies",
        name: "Movies",
        permission: "document",
        read: ["role:all"],
        write: ["role:all"],
        completion: { result in
            switch result {
            case .failure(let error):
                print(error.message)
            case .success(let collection):
                print(collection.toMap())
                collectionId = collection.id
                database.createStringAttribute(
                    collectionId: collection.id,
                    key: "name",
                    size: 60,
                    xrequired: true
                )
                database.createIntegerAttribute(
                    collectionId: collection.id,
                    key: "release_year",
                    xrequired: true,
                    array: false
                )
                database.createFloatAttribute(
                    collectionId: collectionId,
                    key:"rating",
                    xrequired: true,
                    min: "0.0",
                    max: "99.99",
                    array: false
                )
                database.createBooleanAttribute(
                    collectionId: collectionId,
                    key: "kids",
                    xrequired: true,
                    array: false
                )
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
            print(error.message)
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
            print(error.message)
        case .success:
            print("collection deleted")
        }
        group.leave()
    })
    group.wait()
}

func createDocument() {
    let database = Database(client)
    print("Running Add Document API")

    group.enter()
    database.createDocument(
        collectionId: collectionId,
        documentId: "unique()",
        data: [
            "name": "Spider Man",
            "release_year": 1920,
            "rating": 99.5,
            "kids": false
        ],
        read: ["role:all"],
        write: ["role:all"],
        completion: { result in
            switch result {
            case .failure(let error):
                print(error.message)
            case .success(let document):
                documentId = document.id
                print(try! JSONSerialization.data(withJSONObject: document.toMap()))
            }
            group.leave()
        })
    group.wait()
}

func listDocuments() {
    let database = Database(client)
    print("Running List Document API")

    group.enter()
    database.listDocuments(collectionId: collectionId, completion: { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success(let documentList):
            print(try! JSONSerialization.data(withJSONObject: documentList.toMap()))
        }
        group.leave()
    })
    group.wait()
}

func deleteDocument() {
    let database = Database(client)
    print("Running Delete Document API")
    
    group.enter()
    database.deleteDocument(
        collectionId: collectionId,
        documentId: documentId
    ) { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success:
            print("Success")
        }
        group.leave()
    }
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
        fileId: "unique()",
        file: file,
        read: ["role:all"],
        write: [],
        completion: { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success(let file):
            print(try! JSONSerialization.data(withJSONObject: file.toMap()))
        }
        group.leave()
    })
    group.wait()
}

func listFiles() {
    let storage = Storage(client)
    print("Running List File API")
    
    group.enter()
    storage.listFiles { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success(let fileList):
            print(try! JSONSerialization.data(withJSONObject: fileList.toMap()))
        }
        group.leave()
    }
    group.wait()
}

func deleteFile() {
    let storage = Storage(client)
    print("Running Delete File API")

    group.enter()
    storage.deleteFile(fileId: fileId, completion: { result in
        switch result {
        case .failure(let error):
            print(error.message)
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
        functionId: "unique()",
        name: "test function",
        execute: [],
        runtime: "dart-2.14",
        completion: { result in
            switch result {
            case .failure(let error):
                print(error.message)
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
            print(error.message)
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
            print(error.message)
        case .success:
            print("Success")
        }
        group.leave()
    })
    group.wait()
}

main()
