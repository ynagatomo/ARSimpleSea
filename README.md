# AR Simple Sea

![AppIcon](https://user-images.githubusercontent.com/66309582/158568276-cbe373af-9a0f-4048-802c-fdf2cc7ea63f.png)

A minimal iOS AR app that displays a wave animation using RealityKit2 Geometry Modifier.

- Xcode 13.3
- Target: iOS / iPadOS 15.0+
- SwiftUI, ARKit, RealityKit 2, Metal

In iOS 15.0+, you can use RealityKit 2 Geometry Modifier to modify vertices of 3d models with Metal code.
This project shows a sample code that displays a wave animation using a Geometry Modifier.
After some seconds, the image texture of the 3d model will be changed.
This is also RealityKit 2's feature. Please check the code.

The project includes a USDZ file that has sphere object and plane object. I made it with Blender.
The plane is for the surface and has a lot of vertices.
With the Geometry Modifier of RealityKit 2, you can move the vertices and make a wave animation.
Please check the Metal code and modify as you like.

![Image](https://user-images.githubusercontent.com/66309582/158714098-0cd5138d-052d-4914-b55f-9a8e424bc1d9.png)

This is a minimal implementation. Please modify anything you want, and create your own apps.

![Image](https://user-images.githubusercontent.com/66309582/158569315-dd4cf888-67e8-46c6-a14c-62ef2e7a32b7.png)
![Image](https://user-images.githubusercontent.com/66309582/158569339-116953f2-05d3-4bb7-8e04-9a95e6197baf.png)
![GIF](https://user-images.githubusercontent.com/66309582/158587060-be393a42-47f3-423f-8706-2198a59fb9a0.gif)

![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)

