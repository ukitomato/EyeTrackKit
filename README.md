EyeTrackKit
====
- An iOS Framework that enables developers to use eye track information with ARKit content.

## Key Features
- Record eye tracking info
    - face position & rotation
    - eyes position
    - lookAtPosition in World
    - lookAtPoint on device screen
    - blink
    - distance

## Example Projects
To try the example project, simply clone this repository and open the `Examples` folder 

## Compatibility
`EyeTrackKit` is compatible on iOS devices that support [`ARKit`](https://developer.apple.com/documentation/arkit).

`EyeTrackKit` requires:
- Swift UI
- iOS 13
- Swift 5.3 or higher

## Develop Environment
- Language: [Swift](https://developer.apple.com/jp/swift/)
- Xcode: Xcode version 12.0.1 (12A7300)
- Libralies:
  - [ARKit](https://developer.apple.com/jp/documentation/arkit/)
  - [ARVideoKit](https://github.com/AFathi/ARVideoKit)


## Installation
### Swift Package Manager (available Xcode 11.2 and forward)

1. In Xcode, select File > Swift Packages > Add Package Dependency.
2. Follow the prompts using the URL for this repository.

###  [ARVideoKit](https://github.com/AFathi/ARVideoKit)'s settings (This is reference by ARVideoKit's README.md)
1. Make sure you add the usage description of the `camera`, `microphone`, and `photo library` in the app's `Info.plist`.
```
<key>NSCameraUsageDescription</key>
<string>AR Camera</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Export AR Media</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Export AR Media</string>
<key>NSMicrophoneUsageDescription</key>
<string>Audiovisual Recording</string>
```
2.  `import ARVideoKit` in the application delegate `AppDelegate.swift` and a `UIViewController` with an `ARKit` scene.

3. In the application delegate `AppDelegate.swift`, add this 👇 in order to allow the framework access and identify the supported device orientations. **Recommended** if the application supports landscape orientations.
```
func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    return ViewAR.orientation
}
```

## Licence
[MIT](https://github.com/ukitomato/EyeTrackKit/blob/master/LICENSE)

## Author
Yuki Yamato [[ukitomato](https://github.com/ukitomato)]
