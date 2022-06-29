import Appwrite
import NIO
import Foundation

let host = "YOUR_ENDPOINT"
let projectId = "test"
let apiKey = "71cb32ef798c2b7aa53550ab99d67ffe756ea3c7daaaf460fcbd86fd95cb57ae9415a8995ea33ba9d8498f87be5129bb003d94bf452bc25daa7dcc04987bec02319caf0cbda7d20caa5b351638f42577b879506a63d4ba2e06cc53fc1ea33265f57ce788696f05db0ec291e667b44c64df1c29cbe2aaa1a402abe127f353d914"

var databaseId = ""
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

@main
struct Playground {
    static func main() async throws {
        try await createUser()
        try await listUsers()

        try await createDatabase()
        try await createCollection()
        try await listCollection()
        try await createDocument()
        try await listDocuments()
        try await deleteDocument()
        try await deleteCollection()
        try await deleteDatabase()

        try await createFunction()
        try await listFunctions()
        try await deleteFunction()

        try await createBucket()
        try await uploadFile()
        try await listFiles()
        try await deleteFile()
        try await deleteBucket()
        
        print("Playground ran successfully!")
    }
}

func createUser() async throws {
    print("Running create user API")
    let users = Users(client)

    do {
        let user = try await users.create(
            userId: "unique()",
            email: "email@example.com",
            password:"password"
        )
        userId = user.id
        print(user.toMap())
    } catch {
        print(error.localizedDescription)
    }
}

func listUsers() async throws {
    print("Running List Users API")
    let users = Users(client)

    do {
        let userList = try await users.list()
        print(userList.toMap())
    } catch {
        print(error.localizedDescription)
    }
}

func createDatabase() async throws {
    let databases = Databases(client, "moviesDB")
    print("Running Create Database API")

    do {
        let database = try await databases.create(name: "Movies")
        databaseId = database.id
        print(database.toMap())
    } catch {
        print(error.localizedDescription)
    }
}

func deleteDatabase() async throws {
    let databases = Databases(client, databaseId)
    print("Running Delete Database API")

    do {
        _ = try await databases.delete()
        print("Database deleted!")
    } catch {
        print(error.localizedDescription)
    }
}

func createCollection() async throws {
    let databases = Databases(client, databaseId)
    print("Running Create Collection API")

    do {
        let collection = try await databases.createCollection(
            collectionId: "unique()",
            name: "Movies",
            permission: "document",
            read: ["role:all"],
            write: ["role:all"]
        )
        collectionId = collection.id
        print(collection.toMap())

        let stringAttr = try await databases.createStringAttribute(
            collectionId: collectionId,
            key: "name",
            size: 60,
            xrequired: true
        )
        print(stringAttr.toMap())

        let intAttr = try await databases.createIntegerAttribute(
            collectionId: collectionId,
            key: "releaseYear",
            xrequired: true,
            array: false
        )
        print(intAttr.toMap())

        let floatAttr = try await databases.createFloatAttribute(
            collectionId: collectionId,
            key:"rating",
            xrequired: true,
            min: 0.0,
            max: 99.99,
            array: false
        )
        print(floatAttr.toMap())

        let boolAttr = try await databases.createBooleanAttribute(
            collectionId: collectionId,
            key: "kids",
            xrequired: true,
            array: false
        )
        print(boolAttr.toMap())

        sleep(3)

        let index = try await databases.createIndex(
            collectionId: collectionId,
            key: "name_email_index",
            type: "fulltext",
            attributes: ["name", "email"]
        )
        print(index.toMap())
    } catch {
        print(error.localizedDescription)
    }
}

func listCollection() async throws {
    let databases = Databases(client, databaseId)
    print("Running List Collection API")

    do {
        let collectionList = try await databases.listCollections()
        print(collectionList.toMap())
    } catch {
        print(error.localizedDescription)
    }
}

func deleteCollection() async throws {
    let databases = Databases(client, databaseId)
    print("Running Delete Collection API")

    do {
        _ = try await databases.deleteCollection(collectionId: collectionId)
        print("Collection deleted!")
    } catch {
        print(error.localizedDescription)
    }
}

func createDocument() async throws {
    let databases = Databases(client, databaseId)
    print("Running Add Document API")

    do {
        let document = try await databases.createDocument(
            collectionId: collectionId,
            documentId: "unique()",
            data: [
                "name": "The Matrix",
                "releaseYear": 1999,
                "rating": 8.7,
                "kids": true
            ],
            read: ["role:all"],
            write: ["role:all"]
        )
        documentId = document.id
        print(document.toMap())
    } catch {
        print(error.localizedDescription)
    }
}

func listDocuments() async throws {
    let databases = Databases(client, databaseId)
    print("Running List Document API")

    do {
        let documentList = try await databases.listDocuments(collectionId: collectionId)
        print(documentList.toMap())
    } catch {
        print(error.localizedDescription)
    }
}

func deleteDocument() async throws {
    let databases = Databases(client, databaseId)
    print("Running Delete Document API")
    
    do {
        _ = try await databases.deleteDocument(
            collectionId: collectionId, 
            documentId: documentId
        )
        print("Document deleted!")
    } catch {
        print(error.localizedDescription)
    }
}

func createBucket() async throws {
    let storage = Storage(client)
    print("Running Create Bucket API")

    do {
        let bucket = try await storage.createBucket(
            bucketId: "unique()",
            name: "Movies",
            permission: "bucket",
            read: ["role:all"],
            write: ["role:all"]
        )
        bucketId = bucket.id
        print(bucket.toMap())
    } catch {
        print(error.localizedDescription)
    }
}

func uploadFile() async throws {
    let storage = Storage(client)
    print("Running Upload File API")
    
    let file = InputFile.fromPath(Bundle.module.path(
        forResource: "nature",
        ofType: "jpg"
    )!)

    do {
        let file = try await storage.createFile(
            bucketId: bucketId,
            fileId: "unique()",
            file: file,
            read: ["role:all"],
            write: [],
            onProgress: nil
        )
        fileId = file.id
        print(file.toMap())
    } catch {
        print(error.localizedDescription)
    }
}

func listFiles() async throws {
    let storage = Storage(client)
    print("Running List File API")
    
    do {
        let fileList = try await storage.listFiles(bucketId: bucketId)
        print(fileList.toMap())
    } catch {
        print(error.localizedDescription)
    }
}

func deleteFile() async throws {
    let storage = Storage(client)
    print("Running Delete File API")

    do {
        _ = try await storage.deleteFile(
            bucketId: bucketId, 
            fileId: fileId
        )
        print("File deleted!")
    } catch {
        print(error.localizedDescription)
    }
}


func deleteBucket() async throws {
    let storage = Storage(client)
    print("Running Delete Bucket API")

    do {
        _ = try await storage.deleteBucket(bucketId: bucketId)
        print("Bucket deleted!")
    } catch {
        print(error.localizedDescription)
    }
}

func createFunction() async throws {
    let functions = Functions(client)
    print("Running Create Function API")

    do {
        let function = try await functions.create(
            functionId: "unique()",
            name: "Test Function",
            execute: [],
            runtime: "python-3.9"
        )
        functionId = function.id
        print(function.toMap())
    } catch {
        print(error.localizedDescription)
    }
}

func listFunctions() async throws {
    let functions = Functions(client)
    print("Running List Functions API")

    do {
        let functionList = try await functions.list()
        print(functionList.toMap())
    } catch {
        print(error.localizedDescription)
    }
}

func deleteFunction() async throws {
    let functions = Functions(client)
    print("Running Delete Function API")

    do {
        _ = try await functions.delete(functionId: functionId)
        print("Function deleted!")
    } catch {
        print(error.localizedDescription)
    }
}
