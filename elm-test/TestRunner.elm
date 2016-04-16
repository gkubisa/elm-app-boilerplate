module Main where

import Signal exposing (Signal)
import ElmTest exposing (consoleRunner)
import Console exposing (IO, run)
import Task exposing (Task)
import Tests exposing (testSuite)

console : IO ()
console = consoleRunner testSuite

port runner : Signal (Task x ())
port runner = run console
