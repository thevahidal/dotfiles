local function in_dev_tmux()
  if vim.env.NVIM_NO_EXPLORER == "1" then
    return true
  end
  if not vim.env.TMUX then
    return false
  end
  local session = vim.fn.trim(vim.fn.system({ "tmux", "display-message", "-p", "#S" }))
  return session == "build-atlas" or session == "build-edc"
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  -- Replace LazyVim's directory auto-open: skip inside atlas/edc tmux launchers.
  init = function()
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
      desc = "Start Neo-tree with directory",
      once = true,
      callback = function()
        if package.loaded["neo-tree"] then
          return
        end
        if in_dev_tmux() then
          -- Drop the directory buffer so we land on a normal empty buffer.
          vim.schedule(function()
            if vim.fn.argc() > 0 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
              vim.cmd("enew")
            end
          end)
          return
        end
        local stats = vim.uv.fs_stat(vim.fn.argv(0))
        if stats and stats.type == "directory" then
          require("neo-tree")
        end
      end,
    })
  end,
  opts = {
    filesystem = {
      window = {
        position = "left",
        width = 40,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ["l"] = "open",
        },
      },
      filtered_items = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          -- '.git',
          -- '.DS_Store',
          -- 'thumbs.db',
        },
        never_show = {},
      },
    },
  },
}
