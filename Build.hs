#! /usr/bin/env stack
-- stack --resolver lts-11.8 script
{-# LANGUAGE OverloadedStrings #-}

import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util

import Text.Blaze.Svg11 ((!), mkPath, rotate, l, m)
import Text.Blaze.Svg11
import Text.Blaze.Svg11.Attributes (
    transform,
    width,
    height,
    fill,
    viewbox,
    version)
import Text.Blaze.Svg.Renderer.String (renderSvg)

main :: IO ()
main = shakeArgs shakeOptions{shakeFiles="_git-metrics"} $ do
    want ["_git-metrics/report.svg"]

    phony "clean" $ do
        putNormal "Cleaning files in _git-metrics"
        removeFilesAfter "_git-metrics" ["//*"]
    ".git/HEAD" %> \out -> do
        fail "You seam to not be at the root of a git repo"
    "_git-metrics/report.svg" %> \out -> do
        need [".git/HEAD"]
        writeFileChanged out $ renderSvg svgDoc
        
        
svgDoc = docTypeSvg ! version "1.1" ! width "150" ! height "100" ! viewbox "0 0 3 2" $ do
    g ! transform (rotate 50) $ do
        rect ! width "1" ! height "2" ! fill "#008d46"
