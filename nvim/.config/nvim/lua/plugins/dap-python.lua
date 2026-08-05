return {
  "mfussenegger/nvim-dap-python",
  ft = "python",
  dependencies = { "mfussenegger/nvim-dap" },
  opts = {},

  config = function()
    local dap = require("dap")
    local dap_python = require("dap-python")

    dap_python.setup(vim.fn.exepath("python"))

    ----------------------------------------------------------------------
    -- Helpers
    ----------------------------------------------------------------------
    local function django_module_from_current_file()
      local cwd = vim.fn.resolve(vim.fn.getcwd())
      local file = vim.fn.expand("%:p")

      if file == "" then
        return nil
      end

      -- Make file path relative to project root
      local relative = file:gsub("^" .. vim.pesc(cwd) .. "/", "")

      -- Convert path → dotted module
      local module = relative:gsub("/", "."):gsub("%.py$", "")

      return module
    end

    local function get_current_test_label()
      local module = django_module_from_current_file()
      if not module then
        return nil
      end

      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      local cursor = vim.api.nvim_win_get_cursor(0)
      local linenr = cursor[1]

      local test_method, test_class

      -- Find nearest test method above cursor
      for i = linenr, 1, -1 do
        local line = lines[i]
        local m_method = line:match("^%s*def%s+(test_%w+)%s*%(")
        if m_method then
          test_method = m_method
          break
        end
      end

      -- Find nearest test class above cursor
      for i = linenr, 1, -1 do
        local line = lines[i]
        local m_class = line:match("^%s*class%s+(%w+)") -- naive match
        if m_class then
          test_class = m_class
          break
        end
      end

      local label = module
      if test_class then
        label = label .. "." .. test_class
      end
      if test_method then
        label = label .. "." .. test_method
      end

      return label
    end

    ----------------------------------------------------------------------
    -- Django: runserver
    ----------------------------------------------------------------------
    local django_runserver_config = {
      type = "python",
      request = "launch",
      name = "Django Runserver",
      program = "${workspaceFolder}/manage.py",
      args = { "runserver" },
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      justMyCode = false,
    }

    ----------------------------------------------------------------------
    -- Register configs (picker-safe: only static tables)
    ----------------------------------------------------------------------
    dap.configurations.python = {}
    table.insert(dap.configurations.python, 1, django_runserver_config)

    ----------------------------------------------------------------------
    -- Keymaps for dynamic test runs (no picker, safe)
    ----------------------------------------------------------------------
    -- Test current file
    vim.keymap.set("n", "<leader>df", function()
      local module = django_module_from_current_file()
      if not module then
        print("Cannot determine module from current file")
        return
      end

      dap.run({
        type = "python",
        request = "launch",
        name = "Django Test (Current File)",
        program = vim.fn.getcwd() .. "/manage.py",
        args = { "test", module, "--no-color", "--parallel", "--keepdb" },
        cwd = vim.fn.getcwd(),
        console = "integratedTerminal",
        justMyCode = false,
      })
    end, { desc = "Django test (current file)" })

    -- Flexible test input
    vim.keymap.set("n", "<leader>dt", function()
      local label = vim.fn.input("Django test label (e.g. myapp.tests.TestClass.test_method): ")
      if not label or label == "" then
        print("No test label entered")
        return
      end

      dap.run({
        type = "python",
        request = "launch",
        name = "Django Test (Prompt)",
        program = vim.fn.getcwd() .. "/manage.py",
        args = { "test", label, "--no-color", "--parallel", "--keepdb" },
        cwd = vim.fn.getcwd(),
        console = "integratedTerminal",
        justMyCode = false,
      })
    end, { desc = "Django test (prompt)" })

    -- Current test class or method
    vim.keymap.set("n", "<leader>dCf", function()
      local label = get_current_test_label()
      if not label then
        print("Cannot detect test class/method under cursor")
        return
      end

      require("dap").run({
        type = "python",
        request = "launch",
        name = "Django Test (Current Class/Method)",
        program = vim.fn.getcwd() .. "/manage.py",
        args = { "test", label, "--no-color", "--parallel", "--keepdb" },
        cwd = vim.fn.getcwd(),
        console = "integratedTerminal",
        justMyCode = false,
      })
    end, { desc = "Django test (current class/method)" })
  end,
}
