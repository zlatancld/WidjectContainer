# Change Log

## [1.0.1] - 2024-03-12
### Bug Fix
- Resolve parent collection dependencies correctly.
- Prevent memory leaks by clearing reference to initializable instance as soon as it's initialized.

## [1.0.0] - 2024-03-09
### Changes
- Promote package to stable version, after being used and tested for more than a year, ready to be shipped with the first app in mobile stores.
- Expose dependency provider getter within a scope.
- Add tryGet method in dependency provider.
### Bug Fix
- Fix initialization process for scoped and transient bindings, so that parent containers won't hold children references.
- Store scoped instances within container requester, so that parent containers won't hold children references.
- Resolve initialization deadlock caused by requesting an initialized widget from an initialization method.

## [0.1.10] - 2023-06-30
### Bug Fix
- Pass key and args to the scope resolver when resolving a widget through a scope.

## [0.1.9] - 2023-06-11
### Bug Fix
- Initialize instances in parent scopes when initializing a sub-scope.

## [0.1.8] - 2023-05-12
### Bug Fix
- Initialize widget even when not created through a scope.

## [0.1.7] - 2023-03-18
Initialization state.
### Changes
- Provide ReadonlyInitializationState to notify about initialization state changes.
- Add separate initialization method in Scope.

## [0.1.6] - 2023-03-10
### Bug Fix
- Fix singleton resolution when same concrete type is registered in parent as singleton.
- Fix initialization related to singleton resolved in parent scope.

## [0.1.4] - 2023-03-08
### Changes
- Instantiate non-transient initializables when the container is built.

### Bug Fix
- Fix bug in initialization flow causing multiple initialization on the same object during concurrent async calls.

## [0.1.2] - 2023-03-05
### Bug Fix
- Return iterable of required type even when only a single type has been registered.

## [0.1.1] - 2023-03-04
Preparation for pub.dev release.

### Changes
- Move implementation to src folder.
- Add changelog file.

## [0.1.0] - 2023-02-26
Main release with core functionalities.