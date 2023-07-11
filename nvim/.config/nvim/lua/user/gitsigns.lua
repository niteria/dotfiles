require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true, desc = "Next hunk" })

    map("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true, desc = "Previous hunk" })

    -- Actions
    map("n", "<localleader>hs", gs.stage_hunk, { desc = "Stage hunk" })
    map("n", "<localleader>hr", gs.reset_hunk, { desc = "Reset hunk" })
    map("v", "<localleader>hs", function()
      gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Stage selected hunk" })
    map("v", "<localleader>hr", function()
      gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Reset selected hunk" })
    map("n", "<localleader>hS", gs.stage_buffer, { desc = "Stage buffer" })
    map("n", "<localleader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
    map("n", "<localleader>hR", gs.reset_buffer, { desc = "Reset buffer" })
    map("n", "<localleader>hp", gs.preview_hunk, { desc = "Preview hunk" })
    map("n", "<localleader>hb", function()
      gs.blame_line({ full = true })
    end, { desc = "Blame line" })
    map("n", "<localleader>tb", gs.toggle_current_line_blame, { desc = "Toggle blame" })
    map("n", "<localleader>hd", gs.diffthis, { desc = "Diff this" })
    map("n", "<localleader>hD", function()
      gs.diffthis("~")
    end, { desc = "Diff this ~" })
    map("n", "<localleader>td", gs.toggle_deleted, { desc = "Toggle deleted" })

    -- Text object
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
  end,
})
