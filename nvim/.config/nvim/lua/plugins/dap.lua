return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui", -- For UI enhancements
    "jay-babu/mason-nvim-dap.nvim", -- DAP installer
  },
  config = function()
    local dap = require("dap")

    -- Configure DAP for Go
    dap.adapters.go = function(callback, config)
      local handle
      local port = 38697
      handle = vim.loop.spawn("dlv", {
        args = { "dap", "-l", "127.0.0.1:" .. port },
        detached = true,
      }, function(code)
        handle:close()
        print("Delve exited with code:", code)
      end)

      -- Wait for Delve to start
      vim.defer_fn(function()
        callback({ type = "server", host = "127.0.0.1", port = port })
      end, 100)
    end

    -- Define DAP configurations for Go
    dap.configurations.go = {
      {
        type = "go",
        name = "Debug File",
        request = "launch",
        program = "${file}",
      },
      {
        type = "go",
        name = "Debug Package",
        request = "launch",
        program = "./",
      },
      {
        type = "go",
        name = "Attach to Process",
        request = "attach",
        processId = require("dap.utils").pick_process,
      },
    }

    -- Optional: Set up nvim-dap-ui
    require("dapui").setup()

    -- Keybindings for nvim-dap
    vim.keymap.set("n", "<F5>", function()
      dap.continue()
    end, { desc = "Continue Debugging" })
    vim.keymap.set("n", "<F10>", function()
      dap.step_over()
    end, { desc = "Step Over" })
    vim.keymap.set("n", "<F11>", function()
      dap.step_into()
    end, { desc = "Step Into" })
    vim.keymap.set("n", "<F12>", function()
      dap.step_out()
    end, { desc = "Step Out" })
    vim.keymap.set("n", "<leader>db", function()
      dap.toggle_breakpoint()
    end, { desc = "Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>dr", function()
      dap.repl.open()
    end, { desc = "Open REPL" })
    vim.keymap.set("n", "<leader>du", function()
      require("dapui").toggle()
    end, { desc = "Toggle Debug UI" })
  end,
}
