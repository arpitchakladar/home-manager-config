function(bufnr)
  local gitsigns = require('gitsigns')
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  -- Navigation
  map('n', ']c', function() gitsigns.nav_hunk('next') end, 'Next hunk')
  map('n', '[c', function() gitsigns.nav_hunk('prev') end, 'Previous hunk')
  map('n', ']C', function() gitsigns.nav_hunk('last') end, 'Last hunk')
  map('n', '[C', function() gitsigns.nav_hunk('first') end, 'First hunk')

  -- Hunk actions
  map('n', '<leader>gs', gitsigns.stage_hunk, 'Stage hunk')
  map('v', '<leader>gs', function()
    gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
  end, 'Stage visual range hunk')
  map('n', '<leader>gr', gitsigns.reset_hunk, 'Reset hunk')
  map('v', '<leader>gr', function()
    gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
  end, 'Reset visual range hunk')
  map('n', '<leader>gS', gitsigns.stage_buffer, 'Stage buffer')
  map('n', '<leader>gR', gitsigns.reset_buffer, 'Reset buffer')
  map('n', '<leader>gi', gitsigns.reset_buffer_index, 'Unstage buffer (reset index)')
  map('n', '<leader>gu', gitsigns.undo_stage_hunk, 'Undo stage hunk')

  -- Preview
  map('n', '<leader>gp', gitsigns.preview_hunk, 'Preview hunk')
  map('n', '<leader>gP', gitsigns.preview_hunk_inline, 'Preview hunk inline')

  -- Blame
  map('n', '<leader>gb', gitsigns.blame_line, 'Blame line')
  map('n', '<leader>gB', function()
    gitsigns.blame_line({ full = true })
  end, 'Blame line (full)')

  -- Diffs / base
  map('n', '<leader>gd', gitsigns.diffthis, 'Diff this (index)')
  map('n', '<leader>gD', function()
    gitsigns.diffthis('~')
  end, 'Diff this (HEAD)')
  map('n', '<leader>gc', function()
    gitsigns.change_base(nil, true)
  end, 'Change diff base')

  -- Quickfix / location list
  map('n', '<leader>gq', gitsigns.setqflist, 'Hunks to quickfix')
  map('n', '<leader>gQ', function()
    gitsigns.setqflist('all')
  end, 'Repo hunks to quickfix')
  map('n', '<leader>gl', gitsigns.setloclist, 'Hunks to location list')

  -- Toggles
  map('n', '<leader>gts', gitsigns.toggle_signs, 'Toggle signs')
  map('n', '<leader>gtl', gitsigns.toggle_linehl, 'Toggle line highlight')
  map('n', '<leader>gtn', gitsigns.toggle_numhl, 'Toggle number highlight')
  map('n', '<leader>gtw', gitsigns.toggle_word_diff, 'Toggle word diff')
  map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, 'Toggle current line blame')
  map('n', '<leader>gtd', gitsigns.toggle_deleted, 'Toggle deleted lines')

  -- Misc
  map('n', '<leader>gF', gitsigns.refresh, 'Refresh gitsigns')

  -- Text object
  map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, 'Select hunk text object')
end
