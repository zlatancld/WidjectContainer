# Change Log

## [0.1.3] - 2023-03-08

### Changed
- Instantiate non-transient initializables when the container is built.

### Bug Fix
- Fixed bug in initialization flow causing multiple initialization on the same object during concurrent async calls.

## [0.1.2] - 2023-03-05
### Bug Fix
- Return iterable of required type even when only a single type has been registered.

## [0.1.1] - 2023-03-04

Preparation for pub.dev release.

### Changed
- Move implementation to src folder.
- Added changelog file.

## [0.1.0] - 2023-02-26

Main release with core functionalities.