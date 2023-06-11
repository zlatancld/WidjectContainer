# Change Log

## [0.1.9] - 2023-06-11
### Bug Fix
- Initialize instances in parent scopes when initializing a sub-scope.

## [0.1.8] - 2023-05-12
### Bug Fix
- Initialize widget even when not created through a scope.

## [0.1.7] - 2023-03-18
Initialization state.
### Changed
- Provide ReadonlyInitializationState to notify about initialization state changes.
- Add separate initialization method in Scope.

## [0.1.6] - 2023-03-10
### Bug Fix
- Fix singleton resolution when same concrete type is registered in parent as singleton.
- Fix initialization related to singleton resolved in parent scope.

## [0.1.4] - 2023-03-08
### Changed
- Instantiate non-transient initializables when the container is built.

### Bug Fix
- Fix bug in initialization flow causing multiple initialization on the same object during concurrent async calls.

## [0.1.2] - 2023-03-05
### Bug Fix
- Return iterable of required type even when only a single type has been registered.

## [0.1.1] - 2023-03-04
Preparation for pub.dev release.

### Changed
- Move implementation to src folder.
- Add changelog file.

## [0.1.0] - 2023-02-26
Main release with core functionalities.