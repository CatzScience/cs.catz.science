--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
  match "images/*" $ do
    route   idRoute
    compile copyFileCompiler
  match "css/*" $ do
    route   idRoute
    compile compressCssCompiler
  match "about.md" $ do
    route   $ setExtension "html"
    compile $ do
      let aboutCtx =
            constField "page-about" "" `mappend`
            defaultContext
      pandocCompiler
        >>= loadAndApplyTemplate "templates/default.html" aboutCtx
        >>= relativizeUrls
  match "index.md" $ do
    route $ setExtension "html"
    compile $ do
      -- posts <- recentFirst =<< loadAll "posts/*"
      let indexCtx =
            -- listField "posts" postCtx (return posts) `mappend`
            constField "title" "Catz Computer Science Society" `mappend`
            constField "page-index" "" `mappend`
            defaultContext
      pandocCompiler
        >>= applyAsTemplate indexCtx
        >>= loadAndApplyTemplate "templates/default.html" indexCtx
        >>= relativizeUrls
  match "templates/*" $ compile templateBodyCompiler
  -- I don't think we need posts yet
  -- match "posts/*" $ do
  --   route $ setExtension "html"
  --   compile $ pandocCompiler
  --     >>= loadAndApplyTemplate "templates/post.html"    postCtx
  --     >>= loadAndApplyTemplate "templates/default.html" postCtx
  --     >>= relativizeUrls
  -- create ["archive.html"] $ do
  --   route idRoute
  --   compile $ do
  --       posts <- recentFirst =<< loadAll "posts/*"
  --       let archiveCtx =
  --             listField "posts" postCtx (return posts) `mappend`
  --             constField "title" "Archives"            `mappend`
  --             defaultContext
  --       makeItem ""
  --         >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
  --         >>= loadAndApplyTemplate "templates/default.html" archiveCtx
  --         >>= relativizeUrls
--------------------------------------------------------------------------------
-- postCtx :: Context String
-- postCtx =
--   dateField "date" "%B %e, %Y" `mappend`
--   defaultContext
