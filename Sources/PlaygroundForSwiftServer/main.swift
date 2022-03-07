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
    createDocument()
    listDocuments()
    deleteDocument()
    deleteCollection()

    createFunction()
    listFunctions()
    deleteFunction()

    createBucket()
    uploadFile()
    listFiles()
    deleteFile()
    deleteBucket()
    
    print("Playground ran successfully!")
}

func createUser() {
    print("Running create user API")
    let users = Users(client)

    group.enter()
    users.create(
        userId: "unique()",
        email: "email@example.com",
        password:"password"
    ) { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success(let user):
            userId = user.id
            print(user.toMap())
        }
        group.leave()
    }
    group.wait()
}

func listUsers() {
    print("Running List Users API")
    let users = Users(client)

    group.enter()
    users.list { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success(let userList):
            print(userList.toMap())
        }
        group.leave()
    }
    group.wait()
}

func deleteUser() {
    let users = Users(client)
    print("Running Delete User API")

    group.enter()
    users.delete(userId: userId) { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success:
            print("User deleted")
        }
        group.leave()
    }
    group.wait()
}

func createCollection() {
    let database = Database(client)
    print("Running Create Collection API")

    group.enter()
    database.createCollection(
        collectionId: "unique()",
        name: "Movies",
        permission: "document",
        read: ["role:all"],
        write: ["role:all"]
    ) { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success(let collection):
            print(collection.toMap())
            collectionId = collection.id
            
            group.enter()
            database.createStringAttribute(
                collectionId: collectionId,
                key: "name",
                size: 60,
                xrequired: true
            ) { res in
                switch res {
                case .failure(let error):
                    print(error.message)
                case .success(let attr):
                    print(attr.toMap())
                }
                group.leave()
            }
            group.enter()
            database.createIntegerAttribute(
                collectionId: collectionId,
                key: "releaseYear",
                xrequired: true,
                array: false
            ) { res in
                switch res {
                case .failure(let error):
                    print(error.message)
                case .success(let attr):
                    print(attr.toMap())
                }
                group.leave()
            }
            group.enter()
            database.createFloatAttribute(
                collectionId: collectionId,
                key:"rating",
                xrequired: true,
                min: 0.0,
                max: 99.99,
                array: false
            ) { res in
                switch res {
                case .failure(let error):
                    print(error.message)
                case .success(let attr):
                    print(attr.toMap())
                }
                group.leave()
            }
            group.enter()
            database.createBooleanAttribute(
                collectionId: collectionId,
                key: "kids",
                xrequired: true,
                array: false
            ) { res in
                switch res {
                case .failure(let error):
                    print(error.message)
                case .success(let attr):
                    print(attr.toMap())
                }
                group.leave()
            }
            group.enter()
            sleep(3)
            database.createIndex(
                collectionId: collectionId,
                key: "name_email_index",
                type: "fulltext",
                attributes: ["name", "email"]
            ) { res in
                switch res {
                case .failure(let error):
                    print(error.message)
                case .success(let attr):
                    print(attr.toMap())
                }
                sleep(2)
                group.leave()
            }
        }
        group.leave()
    }
    group.wait()
}

func listCollection() {
    let database = Database(client)
    print("Running List Collection API")

    group.enter()
    database.listCollections { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success(let collectionList):
            print(collectionList.toMap())
        }
        group.leave()
    }
    group.wait()
}

func deleteCollection() {
    let database = Database(client)
    print("Running Delete Collection API")

    group.enter()
    database.deleteCollection(collectionId: collectionId) { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success:
            print("Collection deleted")
        }
        group.leave()
    }
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
            "releaseYear": 1920,
            "rating": 99.5,
            "kids": false
        ],
        read: ["role:all"],
        write: ["role:all"]
    ) { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success(let document):
            documentId = document.id
            print(document.toMap())
        }
        group.leave()
    }
    group.wait()
}

func listDocuments() {
    let database = Database(client)
    print("Running List Document API")

    group.enter()
    database.listDocuments(collectionId: collectionId) { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success(let documentList):
            print(documentList.toMap())
        }
        group.leave()
    }
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
        write: ["role:all"]
    ) { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success(let bucket):
            bucketId = bucket.id
            print(bucket.toMap())
        }
        group.leave()
    }
    group.wait()
}

func uploadFile() {
    let storage = Storage(client)
    print("Running Upload File API")

    guard let path = Bundle.module.path(
        forResource: "nature",
        ofType: "jpg"
    ), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
        print("Failed to load resource")
        return
    }
    
    let file = File(
        name: "nature.jpg",
        buffer: ByteBuffer(data: data)
    )

    group.enter()
    storage.createFile(
        bucketId: bucketId,
        fileId: "unique()",
        file: file,
        read: ["role:all"],
        write: [],
        onProgress: nil
    ) { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success(let file):
            fileId = file.id
            print(file.toMap())
        }
        group.leave()
    }
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
    storage.deleteFile(bucketId: bucketId, fileId: fileId) { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success:
            print("File Deleted")
        }
        group.leave()
    }
    group.wait()
}


func deleteBucket() {
    let storage = Storage(client)
    print("Running Delete Bucket API")

    group.enter()
    storage.deleteBucket(bucketId: bucketId) { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success:
            print("Bucket Deleted")
        }
        group.leave()
    }
    group.wait()
}

func createFunction() {
    let functions = Functions(client)
    print("Running Create Function API")

    group.enter()
    functions.create(
        functionId: "unique()",
        name: "Test Function",
        execute: [],
        runtime: "python-3.9"
    ) { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success(let function):
            functionId = function.id
            print(function.toMap())
        }
        group.leave()
    }
    group.wait()
}

func listFunctions() {
    let functions = Functions(client)
    print("Running List Functions API")

    group.enter()
    functions.list { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success(let functionList):
            print(functionList.toMap())
        }
        group.leave()
    }
    group.wait()
}

func deleteFunction() {
    let functions = Functions(client)
    print("Running Delete Function API")

    group.enter()
    functions.delete(functionId: functionId) { result in
        switch result {
        case .failure(let error):
            print(error.message)
        case .success:
            print("Function deleted")
        }
        group.leave()
    }
    group.wait()
}

main()
