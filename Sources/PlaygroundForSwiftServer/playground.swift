import Appwrite
import NIO
import Foundation

let host = "YOUR_ENDPOINT"
let projectId = "test"
let apiKey = "71cb32ef798c2b7aa...3d914"

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
            userId: ID.unique(),
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
    let databases = Databases(client)
    print("Running Create Database API")

    do {
        let database = try await databases.create(
            databaseId: ID.unique(),
            name: "Movies"
        )
        databaseId = database.id
        print(database.toMap())
    } catch {
        print(error.localizedDescription)
    }
}

func deleteDatabase() async throws {
    let databases = Databases(client)
    print("Running Delete Database API")

    do {
        _ = try await databases.delete(databaseId: databaseId)
        print("Database deleted!")
    } catch {
        print(error.localizedDescription)
    }
}

func createCollection() async throws {
    let databases = Databases(client)
    print("Running Create Collection API")

    do {
        let collection = try await databases.createCollection(
            databaseId: databaseId,
            collectionId: ID.unique(),
            name: "Movies",
            permissions: [
                Permission.read(Role.any()),
                Permission.create(Role.users()),
                Permission.update(Role.users()),
                Permission.delete(Role.users())
            ]
        )
        collectionId = collection.id
        print(collection.toMap())

        let stringAttr = try await databases.createStringAttribute(
            databaseId: databaseId,
            collectionId: collectionId,
            key: "name",
            size: 60,
            xrequired: true
        )
        print(stringAttr.toMap())

        let intAttr = try await databases.createIntegerAttribute(
            databaseId: databaseId,
            collectionId: collectionId,
            key: "releaseYear",
            xrequired: true
        )
        print(intAttr.toMap())

        let floatAttr = try await databases.createFloatAttribute(
            databaseId: databaseId,
            collectionId: collectionId,
            key:"rating",
            xrequired: true,
            min: 0.0,
            max: 99.99
        )
        print(floatAttr.toMap())

        let boolAttr = try await databases.createBooleanAttribute(
            databaseId: databaseId,
            collectionId: collectionId,
            key: "kids",
            xrequired: true
        )
        print(boolAttr.toMap())

        let emailAttr = try await databases.createEmailAttribute(
            databaseId: databaseId,
            collectionId: collectionId,
            key: "email",
            xrequired: true
        )
        print(emailAttr.toMap())

        sleep(3)

        let index = try await databases.createIndex(
            databaseId: databaseId,
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
    let databases = Databases(client)
    print("Running List Collection API")

    do {
        let collectionList = try await databases.listCollections(
            databaseId: databaseId
        )
        print(collectionList.toMap())
    } catch {
        print(error.localizedDescription)
    }
}

func deleteCollection() async throws {
    let databases = Databases(client)
    print("Running Delete Collection API")

    do {
        _ = try await databases.deleteCollection(
            databaseId: databaseId,
            collectionId: collectionId
        )
        print("Collection deleted!")
    } catch {
        print(error.localizedDescription)
    }
}

func createDocument() async throws {
    let databases = Databases(client)
    print("Running Add Document API")

    do {
        let document = try await databases.createDocument(
            databaseId: databaseId,
            collectionId: collectionId,
            documentId: ID.unique(),
            data: [
                "name": "The Matrix",
                "releaseYear": 1999,
                "rating": 8.7,
                "kids": false
            ],
            permissions: [
                Permission.read(Role.any())
            ]
        )
        documentId = document.id
        print(document.toMap())
    } catch {
        print(error.localizedDescription)
    }
}

func listDocuments() async throws {
    let databases = Databases(client)
    print("Running List Document API")

    do {
        let documentList = try await databases.listDocuments(
            databaseId: databaseId,
            collectionId: collectionId
        )
        print(documentList.toMap())
    } catch {
        print(error.localizedDescription)
    }
}

func deleteDocument() async throws {
    let databases = Databases(client)
    print("Running Delete Document API")
    
    do {
        _ = try await databases.deleteDocument(
            databaseId: databaseId,
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
            bucketId: ID.unique(),
            name: "Movies",
            permissions: [
                Permission.read(Role.any()),
                Permission.create(Role.users()),
                Permission.update(Role.users()),
                Permission.delete(Role.users())
            ],
            fileSecurity: true
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
            fileId: ID.unique(),
            file: file,
            permissions: [
                Permission.read(Role.any())
            ],
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
        let fileList = try await storage.listFiles(
            bucketId: bucketId
        )
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
            functionId: ID.unique(),
            name: "Test Function",
            execute: [Role.any()],
            runtime: "php-8.0"
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
