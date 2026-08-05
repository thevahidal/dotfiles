-- ~/.config/nvim/lua/plugins/dap-ui.lua

return {
  "rcarriga/nvim-dap-ui",

  -- The main configuration block for nvim-dap-ui
  opts = {
    -- Prevent nvim-dap-ui from opening automatically when a session starts
    controls = {
      layouts = {
        {
          elements = {
            "scopes",
            "breakpoints",
            "stacks",
            "watches",
          },
          size = 0.33, -- Adjust as needed
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 0.67,
        },
      },
      position = "left", -- Where the sidebar appears
      size = 40, -- Width of the sidebar
    },

    -- THIS IS THE CRUCIAL CHANGE:
    open_on_session_start = false,
    -- Also prevent it from closing when the session ends
    close_on_session_end = false,
  },
}
