<!-- GIF Placeholder -->

# Flux

Flux is an iOS app developed for the Apple Swift Student Challenge that transforms sound into sight. Using RealityKit, it turns ambient audio into a stunning, interactive 3D seascape, and integrates recommendations from the National Institute for Occupational Safety and Health (NIOSH) and the World Health Organisation (WHO) to inform users of safe exposure time limits when sound levels are too high. This offers a beautiful and engaging way to promote hearing health awareness.

## Screenshots

<p align="center">
  <img src="Simulator Screenshot - iPhone 17 - 2026-02-08 at 13.21.30.png" width="250" />
  <img src="Simulator Screenshot - iPhone 17 - 2026-02-08 at 13.21.45.png" width="250" />
  <img src="Simulator Screenshot - iPhone 17 - 2026-02-08 at 13.22.02.png" width="250" />
</p>

## Getting Started

This project is packaged as a `.swiftpm` file, which can be run on an iPad or Mac.

### Swift Playgrounds (iPad or Mac)

1. Download the `flux.swiftpm.zip` file.
2. Open the Swift Playgrounds app.
3. AirDrop the `.zip` file to your device, or locate it in the Files app and open it with Swift Playgrounds.

### Xcode (Mac)

For the best development experience or if encountering issues with the `.swiftpm` package, it is recommended to clone the repository and open the Xcode project directly:

1. Clone this repository: `git clone git@github.com:xavierchen0/flux.git`
2. Navigate to the project directory: `cd flux`
3. Open `flux` in Xcode.

## Technologies Used

- **SwiftUI:** For the application's user interface and views.
- **RealityKit:** To create and manage the interactive 3D scene.
- **AVFoundation:** To capture and monitor real-time audio input from the microphone.
