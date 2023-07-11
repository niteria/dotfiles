-- switching back and forth between .cpp and .h files
vim.keymap.set("n", ",s", ":A<CR>")

-- TODO: do it per filetype like
-- https://www.reddit.com/r/vim/comments/76qzoc/advanced_projectionist_templates/doiaxjd
vim.g.projectionist_heuristics = {
  ["*"] = {
    ["*.c"] = {
      alternate = "{}.h",
    },
    ["*.cc"] = {
      alternate = "{}.h",
    },
    ["*.cpp"] = {
      alternate = "{}.h",
    },
    ["*.h"] = {
      alternate = { "{}.cpp", "{}.cc", "{}.c" },
    },
  },
}
