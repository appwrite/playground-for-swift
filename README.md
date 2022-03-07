# Playground for Swift

Simple examples that help you get started with Appwrite + Swift (=❤️)

This is Appwrite server side integration with Swift. For Apple integration please look at our [Apple playground](https://github.com/appwrite/playground-for-apple-swiftui) and [Apple SDK](https://github.com/appwrite/sdk-for-apple)

### Work in progress

Appwrite playground is a simple way to explore the Appwrite API and Appwrite Swift SDK. Use the source code of this page to learn how to use different Appwrite Swift SDK features.

## Get Started
This playground doesn't include any Appwrite best practices, but rather intended to show some of the most simple examples and use cases of using the Appwrite API in your Swift application.

## System Requirements
* An Appwrite instance.
* Create a project in Appwrite instance using console
* Generate a secret key in the Appwrite instance using console

### Installation
1. Clone this repository
2. Open `Sources/PlaygroundForSwiftServer/main.swift` file
3. Copy the project id, endpoint, secret key from the Appwrite Console
4. Update project id, endpoint, secret key by copying from the console in the `Sources/PlaygroundForSwiftServer/main.swift` file
5. Run the playground:
    - Xcode:
        - Click **Run** with the `PlaygroundForSwiftServer` scheme selected
    - Command Line:
        - Execute `swift run` in the root of the repository
    - Docker:
        - Execute `docker compose up` 
6. You will see the JSON response in the console

### API Covered in Playground.
* Create Collection
* List Collection
* Delete Collection
* Add Document
* List Documents
* Upload File
* Delete File
* Create Function
* List Function
* Delete Function
* Create User
* List User
* Delete User

## Contributing

All code contributions - including those of people having commit access - must go through a pull request and approved by a core developer before being merged. This is to ensure proper review of all the code.

We truly ❤️ pull requests! If you wish to help, you can learn more about how you can contribute to this project in the [contribution guide](https://github.com/appwrite/appwrite/blob/master/CONTRIBUTING.md).

## Security

For security issues, kindly email us [security@appwrite.io](mailto:security@appwrite.io) instead of posting a public issue in GitHub.

## Follow Us

Join our growing community around the world! Follow us on [Twitter](https://twitter.com/appwrite), [Facebook Page](https://www.facebook.com/appwrite.io), [Facebook Group](https://www.facebook.com/groups/appwrite.developers/) or join our [Discord Server](https://appwrite.io/discord) for more help, ideas and discussions.
