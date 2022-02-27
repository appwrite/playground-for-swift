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
var bucketId = ""

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
    
    createBucket()
    uploadFile()
    listFiles()
    deleteFile()

    defer {
        deleteBucket()
    }
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
                print(user.toMap())
            }
            group.leave()
        })
    group.wait()
}

func listUsers() {
    print("Running List Users API")
    let users = Users(client)

    group.enter()
    users.list(completion: { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success(let userList):
            print(userList.toMap())
        }
        group.leave()
    })
    group.wait()
}

func deleteUser() {
    let users = Users(client)
    print("Running Delete User API")

    group.enter()
    users.delete(userId: userId, completion: { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success:
            print("User deleted")
        }
        group.leave()
    })
    group.wait()
}

func createCollection() {
    let database = Database(client)
    print("Running Create Collection API")

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
                    min: 0.0,
                    max: 99.99,
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
    print("Running List Collection API")

    group.enter()
    database.listCollections(completion: { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success(let collectionList):
            print(collectionList.toMap())
        }
        group.leave()
    })
    group.wait()
}

func deleteCollection() {
    let database = Database(client)
    print("Running Delete Collection API")

    group.enter()
    database.deleteCollection(collectionId: collectionId, completion: { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success:
            print("Collection deleted")
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
                print(document.toMap())
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
            print(documentList.toMap())
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

func createBucket() {
    let storage = Storage(client)
    print("Running Create Bucket API")

    group.enter()
    storage.createBucket(
        bucketId: "unique()",
        name: "Awesome Bucket",
        permission: "bucket",
        read: ["role:all"],
        write: ["role:all"],
        completion: { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success(let bucket):
            bucketId = bucket.id
            print(bucket.toMap())
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
        bucketId: bucketId,
        fileId: "unique()",
        file: file,
        read: ["role:all"],
        write: [],
        completion: { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success(let file):
            print(file.toMap())
        }
        group.leave()
    })
    group.wait()
}

func listFiles() {
    let storage = Storage(client)
    print("Running List File API")
    
    group.enter()
    storage.listFiles(bucketId: bucketId) { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success(let fileList):
            print(fileList.toMap())
        }
        group.leave()
    }
    group.wait()
}

func deleteFile() {
    let storage = Storage(client)
    print("Running Delete File API")

    group.enter()
    storage.deleteFile(bucketId: bucketId, fileId: fileId, completion: { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success:
            print("File Deleted")
        }
        group.leave()
    })
    group.wait()
}


func deleteBucket() {
    let storage = Storage(client)
    print("Running Delete Bucket API")

    group.enter()
    storage.deleteBucket(bucketId: bucketId, completion: { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success:
            print("Bucket Deleted")
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
                print(function.toMap())
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
            print(functionList.toMap())
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
            print("Function deleted")
        }
        group.leave()
    })
    group.wait()
}

main()
