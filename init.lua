-- ----------------------------------
-- SASS CSS plugin for Dioxus CLI
-- ----------------------------------

local plugin = require("plugin")
local manager = require("manager")

-- deconstruct api functions
local log = plugin.log

-- plugin information
manager.name = "SASS Plugin for Dioxus CLI"
manager.repository = "https://github.com/KurandraEltrueno/sass-plugin"
manager.author = "KurandraEltrueno <12844896+KurandraEltrueno@users.noreply.github.com>"
manager.version = "0.0.1"

-- init manager plugin api
plugin.init(manager)

-- Define paths since we can't reliably get them from the Dioxus CLI.
src_folder = plugin.path.join(plugin.dirs.crate_dir(), "src")
plugin_folder = plugin.path.join(plugin.dirs.crate_dir(), ".dioxus/plugins/sass-plugin")
bin_folder = plugin.path.join(plugin.dirs.crate_dir(), ".dioxus/plugins/sass-plugin/bin/")
-- sass_path = plugin.path.join(plugin.dirs.crate_dir(), ".dioxus/plugins/sass-plugin/bin/sass")
sass_path = "sass"

-- Basically a ternary operator but not really.
-- If Dioxus.toml has a filename defined in `style` then we use that one,
-- otherwise we default to "style.css"
local css_file = plugin.config.dioxus_toml().web.resource.style[1] ~= "" and
plugin.config.dioxus_toml().web.resource.style[1] or "style.css"

local out_dir = plugin.config.dioxus_toml().application.out_dir ~= "" and
plugin.config.dioxus_toml().application.out_dir or "dist"
css_file = out_dir .. "/" .. css_file

-- Hacky way of loading other Lua files
-- download = dofile(plugin_folder .. "/src/download.lua")
-- config = dofile(plugin_folder .. "/src/config.lua")
build = dofile(plugin_folder .. "/src/build.lua")


manager.on_init = function ()
    -- when the first time plugin been load, this function will be execute.
    -- system will create a `dcp.json` file to verify init state.
    log.info("Start to init plugin: " .. manager.name)
    -- TODO
    -- download.download_sass(bin_folder)
    -- TODO - Does sass have a config file?
    -- config.init_config(plugin_folder)
    return true
end

---@param info BuildInfo
manager.build.on_start = function (info)
    -- before the build work start, system will execute this function.
    log.info("Build starting: " .. info.name)
    build.build_css(sass_path, src_folder, css_file)
end

---@param info ServeStartInfo
manager.serve.on_start = function (info)
    -- this function will after clean & print to run, so you can print some thing.
    log.info("Serve start: " .. info.name)
    build.build_css(sass_path, src_folder, css_file)
end

---@param info ServeRebuildInfo
manager.serve.on_rebuild_start = function (info)
    -- this function will after clean & print to run, so you can print some thing.
    local files = plugin.tool.dump(info.changed_files)
    log.info("Serve rebuild: '" .. files .. "'")
    build.build_css(sass_path, src_folder, css_file)
end

manager.serve.on_shutdown = function ()
    --- this function will after serve shutdown.
    log.info("Serve shutdown")
end

return manager