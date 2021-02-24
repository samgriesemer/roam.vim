**Note**: this fork previously contained code for the [Vim-roam](https://github.com/samgriesemer/vim-roam)
project, but has since been moved to its own repo (as linked). _This repo_ will now be used as the primary
`wiki.vim` development fork that Vim-roam depends on. 

## Why this fork exists
As mentioned above, this fork contains the core wiki code that vim-roam depends on. It's
kept separate from the vim-roam repo primarily because

1. This repo primarily contains original wiki.vim code. I think it makes sense to continue
   thinking of wiki.vim as a dependency.
2. This repo is regularly synced with the upstream source to incorporate new wiki.vim
   features and fixes. 

The code here modifies internal functionality and exposes a slightly altered option set
than the original wiki.vim repo. This is to enable certain features for vim-roam that are
outside the scope of the original wiki.vim project. The core differences will be fully
documented soon.

## New link options

- `wiki_map_text_to_file`
- `wiki_map_link_to_file`
- `wiki_map_text_to_link`
- `wiki_map_file_to_link`
- `wiki_link_conceal`

