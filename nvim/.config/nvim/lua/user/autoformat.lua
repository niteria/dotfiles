vim.g.autoformat_autoindent = 0
vim.g.autoformat_retab = 0
-- https://github.com/vim-autoformat/vim-autoformat#help-the-formatter-doesnt-work-as-expected
vim.g.formatdef_fourmolu = '"exec 2> /dev/null; fourmolu --no-cabal"'
vim.g.formatdef_stylish_haskell = '"stylish-haskell"'
vim.g.formatters_haskell = { "fourmolu", "stylish_haskell" }
vim.g.run_all_formatters_haskell = 1

vim.g.formatdef_purs_tidy = '"purs-tidy format"'
vim.g.formatters_purescript = { "purs_tidy" }

-- We limit formatting to BUILD.bazel files because without specifying -type
-- buildifier won't sort dependencies.
-- If we wanted to extend this, we'd probably need a separate definition for
-- each bazel -type
vim.g.formatdef_buildifier = '"buildifier -type build"'
