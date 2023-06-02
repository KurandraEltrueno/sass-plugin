-- ----------------------------------
-- Tailwind CSS plugin for Dioxus CLI
-- ----------------------------------
--
-- This module deals with building the CSS file using Tailwind.
--
-- This function will be ran after every build and server reload.
-- Runs Tailwind CSS using the project config files,
-- and generates a CSS file.


local build = {}
local plugin = require("plugin")

function build.build_css(executable, src_folder, css_file)
  build.run_sass(executable, src_folder, css_file)
end

function build.run_sass(executable, src_folder, css_file)
  --- Runs SASS and builds the CSS file in the ./public folder.

  plugin.log.info("Building CSS...")
  plugin.command.exec(
  { executable, src_folder .. "/index.scss", css_file }, "inhert", "inhert")
end

return build