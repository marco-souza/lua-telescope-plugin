local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local previewers = require('telescope.previewers')
local utils = require('telescope.previewers.utils')
local config = require('telescope.config').values

local actions = require('telescope.actions')
local actions_state = require('telescope.actions.state')

local log = require('plenary.log'):new()

log.level = "debug"

local M = {}

local finder = finders.new_async_job({
  command_generator = function()
    return { "docker", "images", "--format", "json" }
  end,
  entry_maker = function(entry)
    local parsed = vim.json.decode(entry)

    log.debug(parsed)

    if parsed then
      return {
        value = parsed,
        display = parsed.Repository, -- display key
        ordinal =
            vim.iter({
              parsed.Repository,
              parsed.Tag,
              parsed.ID,
            })
            :join(":"), -- sorting key
      }
    end
  end
})

local previewer = previewers.new_buffer_previewer({
  title = "Docker Image Details",
  define_preview = function(self, entry)
    vim.api.nvim_buf_set_lines(
      self.state.bufnr,
      0, -1, false,
      vim.iter({
        "ID: " .. entry.value.ID,
        "",
        "```lua",
        vim.split(vim.inspect(entry.value), "\n", nil),
        "```",
      })
      :flatten()
      :totable()
    )

    utils.highlighter(self.state.bufnr, "markdown")
  end
})

M.show_docker_images = function(opts)
  pickers.new(opts, {
    finder = finder,
    sorter = config.generic_sorter(opts),
    previewer = previewer,
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = actions_state.get_selected_entry()
        actions.close(prompt_bufnr)

        log.debug("Selected: " .. selection.display)

        local command = {
          "term",
          "docker",
          "run",
          "-it",
          "--rm",
          selection.value.Repository,
        }

        log.debug("Running command: " .. vim.inspect(command))

        vim.cmd(vim.iter(command):join(" "))
      end)

      return true
    end
  }):find()

  print("Showing docker images")
end

M.show_docker_images()

return M
