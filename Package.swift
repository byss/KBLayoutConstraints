// swift-tools-version:5.3

import PackageDescription

private let libraryName = "KBLayoutConstraints";

let package = Package (
	name: libraryName,
	platforms: [.iOS (.v9), .tvOS (.v9)],
	products: [ .library (name: libraryName, targets: [libraryName]) ],
	targets: [ .target (name: libraryName, path: ".", exclude: ["README.md", "LICENSE"]) ]
);
