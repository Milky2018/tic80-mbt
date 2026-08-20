// Compatibility methods that were previously promoted implicitly from trait
// implementations. Use the traits or operators directly in new code.

///|
#deprecated("Use `Debug::to_repr` instead", skip_current_package=true)
#doc(hidden)
pub extend Button with Debug::{to_repr}

///|
#deprecated("Use `==` or `!=` instead", skip_current_package=true)
#doc(hidden)
pub extend Button with Eq::{not_equal, equal}

///|
#deprecated("Use `Debug::to_repr` instead", skip_current_package=true)
#doc(hidden)
pub extend ButtonState with Debug::{to_repr}

///|
#deprecated("Use `==` or `!=` instead", skip_current_package=true)
#doc(hidden)
pub extend ButtonState with Eq::{not_equal, equal}

///|
#deprecated("Use `Debug::to_repr` instead", skip_current_package=true)
#doc(hidden)
pub extend Key with Debug::{to_repr}

///|
#deprecated("Use `==` or `!=` instead", skip_current_package=true)
#doc(hidden)
pub extend Key with Eq::{not_equal, equal}

///|
#deprecated("Use `Debug::to_repr` instead", skip_current_package=true)
#doc(hidden)
pub extend Flip with Debug::{to_repr}

///|
#deprecated("Use `==` or `!=` instead", skip_current_package=true)
#doc(hidden)
pub extend Flip with Eq::{not_equal, equal}

///|
#deprecated("Use `Debug::to_repr` instead", skip_current_package=true)
#doc(hidden)
pub extend Rotation with Debug::{to_repr}

///|
#deprecated("Use `==` or `!=` instead", skip_current_package=true)
#doc(hidden)
pub extend Rotation with Eq::{not_equal, equal}

///|
#deprecated("Use `Debug::to_repr` instead", skip_current_package=true)
#doc(hidden)
pub extend MapRemapResult with Debug::{to_repr}

///|
#deprecated("Use `==` or `!=` instead", skip_current_package=true)
#doc(hidden)
pub extend MapRemapResult with Eq::{not_equal, equal}

///|
#deprecated("Use `Debug::to_repr` instead", skip_current_package=true)
#doc(hidden)
pub extend MouseState with Debug::{to_repr}

///|
#deprecated("Use `==` or `!=` instead", skip_current_package=true)
#doc(hidden)
pub extend MouseState with Eq::{not_equal, equal}

///|
#deprecated("Use `Debug::to_repr` instead", skip_current_package=true)
#doc(hidden)
pub extend SfxChannel with Debug::{to_repr}

///|
#deprecated("Use `==` or `!=` instead", skip_current_package=true)
#doc(hidden)
pub extend SfxChannel with Eq::{not_equal, equal}

///|
#deprecated("Use `Debug::to_repr` instead", skip_current_package=true)
#doc(hidden)
pub extend SyncSection with Debug::{to_repr}

///|
#deprecated("Use `==` or `!=` instead", skip_current_package=true)
#doc(hidden)
pub extend SyncSection with Eq::{not_equal, equal}

///|
#deprecated("Use `Debug::to_repr` instead", skip_current_package=true)
#doc(hidden)
pub extend TextureSource with Debug::{to_repr}

///|
#deprecated("Use `==` or `!=` instead", skip_current_package=true)
#doc(hidden)
pub extend TextureSource with Eq::{not_equal, equal}

///|
#deprecated("Use `Debug::to_repr` instead", skip_current_package=true)
#doc(hidden)
pub extend VideoBank with Debug::{to_repr}

///|
#deprecated("Use `==` or `!=` instead", skip_current_package=true)
#doc(hidden)
pub extend VideoBank with Eq::{not_equal, equal}
