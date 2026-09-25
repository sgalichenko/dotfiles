-- Git integration
return {
  {'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('gitsigns').setup({
        on_attach = function(bufnr)
          local gs = require('gitsigns')
          -- ]c / [c: next/prev hunk (falls back to default in diff mode)
          -- like git-gutter in vim
          vim.keymap.set('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.nav_hunk('next') end)
            return '<Ignore>'
          end, { expr = true, buffer = bufnr, desc = 'Next hunk' })
          vim.keymap.set('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.nav_hunk('prev') end)
            return '<Ignore>'
          end, { expr = true, buffer = bufnr, desc = 'Prev hunk' })
          vim.keymap.set('n', '<leader>s', gs.stage_hunk, { buffer = bufnr, desc = 'Stage hunk' })
          vim.keymap.set('n', '<leader>u', gs.reset_hunk, { buffer = bufnr, desc = 'Reset hunk' })
        end,
      })
    end,
    },
  {'tpope/vim-fugitive',
    cmd = { 'G', 'Git', 'Gdiffsplit', 'Gvdiffsplit', 'Gread', 'Gwrite', 'Gedit', 'GBrowse' },
  }
}
