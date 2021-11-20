{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -Wno-missing-safe-haskell-mode #-}
module Paths_nnf_to_dot (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/ruso/.cabal/bin"
libdir     = "/home/ruso/.cabal/lib/x86_64-linux-ghc-9.0.1/nnf-to-dot-0.1.0.0-inplace-nnf-to-dot"
dynlibdir  = "/home/ruso/.cabal/lib/x86_64-linux-ghc-9.0.1"
datadir    = "/home/ruso/.cabal/share/x86_64-linux-ghc-9.0.1/nnf-to-dot-0.1.0.0"
libexecdir = "/home/ruso/.cabal/libexec/x86_64-linux-ghc-9.0.1/nnf-to-dot-0.1.0.0"
sysconfdir = "/home/ruso/.cabal/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "nnf_to_dot_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "nnf_to_dot_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "nnf_to_dot_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "nnf_to_dot_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "nnf_to_dot_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "nnf_to_dot_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
