# Flux
Flux is an iOS app developed for the **Apple Swift Student Challenge 2026** that transforms sound into sight. Using RealityKit, it turns ambient audio into a stunning, interactive 3D seascape, and integrates recommendations from the National Institute for Occupational Safety and Health (NIOSH) and the World Health Organisation (WHO) to inform users of safe exposure time limits when sound levels are too high. This offers a beautiful and engaging way to promote hearing health awareness.

<div align = "center">
  <video src="https://github.com/user-attachments/assets/524bf737-909f-41ee-96a1-441cbb6fedd9" width="600"></video>
</div>

## Screenshots

<p align="center">
  <img width="250" alt="Main View" src="https://github.com/user-attachments/assets/ebe96166-fb22-4152-a69f-cf8862f7a5a5" />

  <img width="250" alt="Info View" src="https://github.com/user-attachments/assets/c8ba932c-3555-4411-b93b-851f9e30bb23" />

  <img width="250" alt="Settings View" src="https://github.com/user-attachments/assets/0bfb16c0-44e9-4f57-94cb-0bfa2d4a2c40" />
</p>

## Getting Started

This project is packaged as a `.swiftpm` file, which can be run on an iPad or Mac.

### Xcode (Mac)

For the best development experience or if encountering issues with the `.swiftpm` package, it is recommended to clone the repository and open the Xcode project directly:

1. Clone this repository: `git clone git@github.com:xavierchen0/flux.git`
2. Navigate to the project directory: `cd flux`
3. Open `flux` in Xcode.

### Swift Playgrounds (iPad or Mac)

1. Download the `flux.swiftpm.zip` file and unzip it.
2. Open the Swift Playgrounds app.

## Technologies Used

- **SwiftUI:** For the application's user interface and views.
- **RealityKit:** To create and manage the interactive 3D scene.
- **AVFoundation:** To capture and monitor real-time audio input from the microphone.
