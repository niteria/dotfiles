local status_ok, builtin = pcall(require, "telescope.builtin")

if not status_ok then
  return
end

local status_ok2, telescope = pcall(require, "telescope")

if not status_ok2 then
  return
end

-- Cherry-picking https://github.com/nvim-telescope/telescope.nvim/pull/2333
local function grep_string(opts)
  local conf = require("telescope.config").values

  local escape_chars = function(string)
    return string.gsub(string, "[%(|%)|\\|%[|%]|%-|%{%}|%?|%+|%*|%^|%$|%.]", {
      ["\\"] = "\\\\",
      ["-"] = "\\-",
      ["("] = "\\(",
      [")"] = "\\)",
      ["["] = "\\[",
      ["]"] = "\\]",
      ["{"] = "\\{",
      ["}"] = "\\}",
      ["?"] = "\\?",
      ["+"] = "\\+",
      ["*"] = "\\*",
      ["^"] = "\\^",
      ["$"] = "\\$",
      ["."] = "\\.",
    })
  end
  local flatten = vim.tbl_flatten
  -- I don't need this
  local opts_contain_invert = function(args)
    return false
  end
  -- or this?
  local get_open_filelist = function(grep_open_files, cwd)
    return nil
  end

  local make_entry = require("telescope.make_entry")
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")

  opts = opts or {}
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
  local vimgrep_arguments = vim.F.if_nil(opts.vimgrep_arguments, conf.vimgrep_arguments)
  local word
  local visual = vim.fn.mode() == "v"

  if visual == true then
    local saved_reg = vim.fn.getreg("v")
    vim.cmd([[noautocmd sil norm "vy]])
    local sele = vim.fn.getreg("v")
    vim.fn.setreg("v", saved_reg)
    word = vim.F.if_nil(opts.search, sele)
  else
    word = vim.F.if_nil(opts.search, vim.fn.expand("<cword>"))
  end
  local search = opts.use_regex and word or escape_chars(word)

  local additional_args = {}
  if opts.additional_args ~= nil then
    if type(opts.additional_args) == "function" then
      additional_args = opts.additional_args(opts)
    elseif type(opts.additional_args) == "table" then
      additional_args = opts.additional_args
    end
  end

  if search == "" then
    search = { "-v", "--", "^[[:space:]]*$" }
  else
    search = { "--", search }
  end

  local args
  if visual == true then
    args = flatten({
      vimgrep_arguments,
      additional_args,
      search,
    })
  else
    args = flatten({
      vimgrep_arguments,
      additional_args,
      opts.word_match,
      search,
    })
  end

  opts.__inverted, opts.__matches = opts_contain_invert(args)

  if opts.grep_open_files then
    for _, file in ipairs(get_open_filelist(opts.grep_open_files, opts.cwd)) do
      table.insert(args, file)
    end
  elseif opts.search_dirs then
    for _, path in ipairs(opts.search_dirs) do
      table.insert(args, vim.fn.expand(path))
    end
  end

  opts.entry_maker = opts.entry_maker or make_entry.gen_from_vimgrep(opts)
  pickers
    .new(opts, {
      prompt_title = "Find Word (" .. word:gsub("\n", "\\n") .. ")",
      finder = finders.new_oneshot_job(args, opts),
      previewer = conf.grep_previewer(opts),
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

vim.keymap.set("n", "<localleader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<localleader>fg", builtin.live_grep, { desc = "Grep" })
vim.keymap.set("n", "<localleader>fb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<localleader>fh", builtin.help_tags, { desc = "Find help" })
vim.keymap.set("n", "<localleader>fc", builtin.git_status, { desc = "Find changes" })
vim.keymap.set("n", "<localleader>fo", builtin.oldfiles, { desc = "Find old files" })
vim.keymap.set("n", "<localleader>fa", builtin.builtin, { desc = "Find finders" })
vim.keymap.set("n", "G", builtin.grep_string, { desc = "Grep string" })
vim.keymap.set("v", "G", grep_string, { desc = "Grep string" })

telescope.load_extension("hoogle")
