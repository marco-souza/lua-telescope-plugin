local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local previewers = require('telescope.previewers')
local utils = require('telescope.previewers.utils')
local config = require('telescope.config').values

local log = require('plenary.log'):new()

log.level = "debug"

local M = {}

M.show_docker_images = function(opts)
  pickers.new(opts, {
    finder = finders.new_async_job({
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
    }),

    sorter = config.generic_sorter(opts),
    previewer = previewers.new_buffer_previewer({
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
    }),
  }):find()

  print("Showing docker images")
end

M.show_docker_images()

return M
