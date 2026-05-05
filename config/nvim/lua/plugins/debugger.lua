-- =============================================================================
-- dap.lua — Debug Adapter Protocol configuration for Neovim
-- Compatible with: lazy.nvim plugin manager
-- Covers: nvim-dap, nvim-dap-ui, nvim-dap-virtual-text, telescope-dap, codelldb
--
-- ─── EXTERNAL DEPENDENCIES (install these BEFORE sourcing this file) ──────────
--
--  1. codelldb  (the debug adapter binary — NOT installed via Mason)
--     Download the latest release for your platform from:
--       https://github.com/vadimcn/codelldb/releases
--     The asset is named  codelldb-<arch>-<os>.vsix  (it is a ZIP file).
--
--     Linux x86_64:
--       CODELLDB_VERSION="1.11.2"
--       curl -L -o /tmp/codelldb.vsix \
--         "https://github.com/vadimcn/codelldb/releases/download/v${CODELLDB_VERSION}/codelldb-x86_64-linux.vsix"
--       mkdir -p ~/.local/share/codelldb
--       unzip -o /tmp/codelldb.vsix -d ~/.local/share/codelldb
--       # adapter binary → ~/.local/share/codelldb/extension/adapter/codelldb
--
--     macOS arm64 (Apple Silicon):
--       Replace "x86_64-linux" with "aarch64-darwin" in the URL above.
--
--     Arch Linux (AUR):
--       yay -S codelldb-bin
--       # adapter binary → /usr/bin/codelldb
--
--     Override at any time via an environment variable:
--       export CODELLDB_PATH=/path/to/codelldb
--
--  2. Compiler with debug symbols
--     • clang / clang++  — compile with -g (pairs naturally with LLDB)
--     • gcc / g++        — compile with -ggdb
--     • cargo            — debug builds include symbols by default
--
--  3. Nerd Font (optional, for nvim-dap-ui icons)
--     https://www.nerdfonts.com/
--
-- =============================================================================

-- Locate the codelldb binary, checking common install locations.
local function get_codelldb_path()
  -- 1. Explicit env-var override
  local env = vim.env.CODELLDB_PATH
  if env and vim.fn.executable(env) == 1 then return env end

  -- 2. Default manual-extraction path
  local default = vim.fn.expand("~/.local/share/codelldb/extension/adapter/codelldb")
  if vim.fn.executable(default) == 1 then return default end

  -- 3. Arch Linux AUR package / anything else on $PATH
  if vim.fn.executable("codelldb") == 1 then return "codelldb" end

  return nil
end

-- =============================================================================
-- lazy.nvim plugin specifications
-- Place this file at:  ~/.config/nvim/lua/plugins/dap.lua
-- =============================================================================
return {

  -- ── 1. nvim-dap (core DAP client) ──────────────────────────────────────────
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",               -- required by nvim-dap-ui
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",   -- telescope pickers for DAP
    },
    -- Lazy-load on any <leader>d keybinding
    keys = {
      { "<leader>dc",  desc = "Debug: Continue / Start" },
      { "<leader>dC",  desc = "Debug: Run to Cursor" },
      { "<leader>di",  desc = "Debug: Step Into" },
      { "<leader>do",  desc = "Debug: Step Over" },
      { "<leader>dO",  desc = "Debug: Step Out" },
      { "<leader>dl",  desc = "Debug: Run Last" },
      { "<leader>dr",  desc = "Debug: Restart" },
      { "<leader>dx",  desc = "Debug: Terminate" },
      { "<leader>db",  desc = "Debug: Toggle Breakpoint" },
      { "<leader>dB",  desc = "Debug: Conditional Breakpoint" },
      { "<leader>dL",  desc = "Debug: Log-point" },
      { "<leader>dxb", desc = "Debug: Clear All Breakpoints" },
      { "<leader>du",  desc = "Debug: Toggle UI" },
      { "<leader>de",  desc = "Debug: Eval",  mode = { "n", "v" } },
      -- telescope-dap pickers
      { "<leader>dtc", desc = "Debug: Telescope Commands" },
      { "<leader>dtf", desc = "Debug: Telescope Configurations" },
      { "<leader>dtb", desc = "Debug: Telescope Breakpoints" },
      { "<leader>dtv", desc = "Debug: Telescope Variables" },
      { "<leader>dts", desc = "Debug: Telescope Frames (Stack)" },
    },

    config = function()
      local dap   = require("dap")
      local dapui = require("dapui")

      -- ── telescope-dap ────────────────────────────────────────────────────
      -- Must be called after nvim-dap is configured. This also overrides the
      -- DAP internal UI so any dap command that opens a selection prompt will
      -- use a Telescope picker instead.
      require("telescope").load_extension("dap")

      -- ── nvim-dap-virtual-text ───────────────────────────────────────────
      -- All options match the plugin defaults; a bare setup() activates it.
      require("nvim-dap-virtual-text").setup()

      -- ── nvim-dap-ui ─────────────────────────────────────────────────────
      -- All options match the plugin defaults; a bare setup() activates it.
      dapui.setup()

      -- Auto-open/-close the UI with the debug session.
      -- This wiring is NOT done automatically by nvim-dap-ui; it must be set
      -- up manually via dap.listeners (see nvim-dap-ui README).
      dap.listeners.before.attach.dapui_config           = function() dapui.open() end
      dap.listeners.before.launch.dapui_config           = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config     = function() dapui.close() end

      -- ── Breakpoint signs ────────────────────────────────────────────────
      -- nvim-dap registers these sign names but leaves text/highlights empty.
      -- Defining them here is a genuine customisation (not a default override).
      vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition" })
      vim.fn.sign_define("DapBreakpointRejected",  { text = "○", texthl = "DapBreakpointRejected" })
      vim.fn.sign_define("DapLogPoint",            { text = "▲", texthl = "DapLogPoint" })
      vim.fn.sign_define("DapStopped",             { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine" })

      vim.api.nvim_set_hl(0, "DapBreakpoint",          { fg = "#e06c75" })
      vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#e5c07b" })
      vim.api.nvim_set_hl(0, "DapBreakpointRejected",  { fg = "#5c6370" })
      vim.api.nvim_set_hl(0, "DapLogPoint",            { fg = "#61afef" })
      vim.api.nvim_set_hl(0, "DapStopped",             { fg = "#98c379" })
      vim.api.nvim_set_hl(0, "DapStoppedLine",         { bg = "#2e3a28" })

      -- ── codelldb adapter ────────────────────────────────────────────────
      local codelldb_cmd = get_codelldb_path()

      if codelldb_cmd then
        dap.adapters.codelldb = {
          type = "server",
          port = "${port}",
          executable = {
            command = codelldb_cmd,
            args    = { "--port", "${port}" },
          },
        }
      else
        vim.notify(
          "[nvim-dap] codelldb not found.\n"
            .. "See install instructions at the top of dap.lua, or\n"
            .. "set the CODELLDB_PATH environment variable.",
          vim.log.levels.WARN,
          { title = "nvim-dap" }
        )
      end

      -- ── Debug configurations ────────────────────────────────────────────
      -- Prompts for the executable, pre-filling likely output paths.
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

            -- ── Telescope-based process picker ──────────────────────────────────
      -- Replaces dap.utils.pick_process with a full Telescope UI.
      -- Shows PID, process name, and full command line; supports live filtering.
      local function pick_process()
        -- Collect running processes via `ps`.
        -- Works on Linux and macOS; the columns are: pid, comm, args.
        local proc_lines = vim.fn.systemlist("ps -eo pid,comm,args --no-headers 2>/dev/null || ps -eo pid,comm,args 2>/dev/null")

        local procs = {}
        for _, line in ipairs(proc_lines) do
          -- Parse: leading whitespace, pid, space, comm, space, args
          local pid, comm, args = line:match("^%s*(%d+)%s+(%S+)%s+(.*)")
          if pid and comm then
            table.insert(procs, {
              pid   = tonumber(pid),
              comm  = comm,
              args  = args or "",
              -- Display string shown in the picker
              display = string.format("[%6s]  %-25s  %s", pid, comm, args),
            })
          end
        end

        -- Return a promise-like value via coroutine so nvim-dap can await it.
        local co = coroutine.running()
        pickers.new({}, {
          prompt_title  = "Attach to Process",
          finder        = finders.new_table({
            results = procs,
            entry_maker = function(proc)
              return {
                value   = proc,
                display = proc.display,
                ordinal = proc.display,   -- searched field
              }
            end,
          }),
          sorter = conf.generic_sorter({}),
          attach_mappings = function(prompt_bufnr)
            -- <CR> confirms selection and resumes the DAP coroutine
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local sel = action_state.get_selected_entry()
              if sel then
                coroutine.resume(co, sel.value.pid)
              else
                coroutine.resume(co, nil)
              end
            end)
            -- <Esc> / q cancels without attaching
            actions.close:enhance({
              post = function()
                if coroutine.status(co) == "suspended" then
                  coroutine.resume(co, nil)
                end
              end,
            })
            return true
          end,
        }):find()

        -- Yield until the picker resumes us with a pid (or nil on cancel)
        return coroutine.yield()
      end

      local function pick_executable()
        return coroutine.create(function(coro)
            local opts = {}
            pickers
            .new(opts, {
                prompt_title = "Path to executable",
                finder = finders.new_oneshot_job({ "fd", "--hidden", "--no-ignore", "--type", "x" }, {}),
                sorter = conf.generic_sorter(opts),
                attach_mappings = function(buffer_number)
                actions.select_default:replace(function()
                    actions.close(buffer_number)
                    coroutine.resume(coro, action_state.get_selected_entry()[1])
                end)
                return true
                end,
            })
            :find()
        end)
      end

      -- C
      dap.configurations.c = {
        {
          name    = "Launch (C)",
          type    = "codelldb",
          request = "launch",
          program = pick_executable,
          cwd     = "${workspaceFolder}",
        },
        {
          name    = "Attach to process (C)",
          type    = "codelldb",
          request = "attach",
          pid     = pick_process,
          cwd     = "${workspaceFolder}",
        },
      }

      -- C++ — same as C configs
      dap.configurations.cpp = vim.deepcopy(dap.configurations.c)
      for _, cfg in ipairs(dap.configurations.cpp) do
        cfg.name = cfg.name:gsub("%(C%)", "(C++)")
      end

      -- Rust — adds `expressions = "native"` for richer type display via codelldb
      dap.configurations.rust = {
        {
          name        = "Launch (Rust)",
          type        = "codelldb",
          request     = "launch",
          program     = pick_executable,
          cwd         = "${workspaceFolder}",
          expressions = "native",   -- codelldb-specific; enables native Rust type display
        },
        {
          name    = "Attach to process (Rust)",
          type    = "codelldb",
          request = "attach",
          pid     = pick_process,
          cwd     = "${workspaceFolder}",
        },
      }

      -- ── Keymaps ─────────────────────────────────────────────────────────
      local map = function(lhs, rhs, desc, mode)
        vim.keymap.set(mode or "n", lhs, rhs, { desc = desc })
      end

      -- Session control
      map("<leader>dc",  dap.continue,       "Debug: Continue / Start")
      map("<leader>dC",  dap.run_to_cursor,  "Debug: Run to Cursor")
      map("<leader>di",  dap.step_into,      "Debug: Step Into")
      map("<leader>do",  dap.step_over,      "Debug: Step Over")
      map("<leader>dO",  dap.step_out,       "Debug: Step Out")
      map("<leader>dl",  dap.run_last,       "Debug: Run Last")
      map("<leader>dr",  dap.restart,        "Debug: Restart")
      map("<leader>dx",  dap.terminate,      "Debug: Terminate")

      -- Breakpoints
      map("<leader>db",  dap.toggle_breakpoint, "Debug: Toggle Breakpoint")
      map("<leader>dB",  function()
        dap.set_breakpoint(vim.fn.input("Condition: "))
      end, "Debug: Conditional Breakpoint")
      map("<leader>dL",  function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
      end, "Debug: Log-point")
      map("<leader>dxb", dap.clear_breakpoints, "Debug: Clear All Breakpoints")

      -- Toggle the full DAP UI
      map("<leader>du",  dapui.toggle, "Debug: Toggle UI")

      -- Evaluate expression under cursor (normal) or visual selection
      map("<leader>de", function() dapui.eval() end, "Debug: Eval Expression")
      map("<leader>de", function() dapui.eval() end, "Debug: Eval Selection", "v")

      -- ── telescope-dap pickers ────────────────────────────────────────────
      -- telescope-dap overrides the DAP internal UI, so these pickers also
      -- drive any built-in dap prompts (e.g. selecting a configuration on :DapContinue).
      local tdap = require("telescope").extensions.dap
      map("<leader>dtc", tdap.commands,          "Debug: Telescope Commands")
      map("<leader>dtf", tdap.configurations,    "Debug: Telescope Configurations")
      map("<leader>dtb", tdap.list_breakpoints,  "Debug: Telescope Breakpoints")
      map("<leader>dtv", tdap.variables,         "Debug: Telescope Variables")
      map("<leader>dts", tdap.frames,            "Debug: Telescope Frames (Stack)")

    end,
  },

  -- ── 2. nvim-dap-ui ─────────────────────────────────────────────────────────
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
  },

  -- ── 3. nvim-nio (required by nvim-dap-ui) ──────────────────────────────────
  { "nvim-neotest/nvim-nio" },

  -- ── 4. nvim-dap-virtual-text ────────────────────────────────────────────────
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
  },

  -- ── 5. telescope-dap ────────────────────────────────────────────────────────
  -- Provides telescope pickers for DAP commands, configurations, breakpoints,
  -- variables, and stack frames. Also overrides the DAP internal selection UI.
  {
    "nvim-telescope/telescope-dap.nvim",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-telescope/telescope.nvim",
    },
  },

} -- end return
