return {
  "folke/snacks.nvim",
  lazy = false,
  opts = {
    dashboard = {
      enabled = true,
      width = 60,
      pane_gap = 4, -- empty columns between vertical panes
      autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
      -- These settings are used by some built-in sections
      preset = {
        -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
        -- Used by the `keys` section to show keymaps.
        -- Set your custom keymaps here.
        -- When using a function, the `items` argument are the default keymaps.
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        -- Used by the `header` section
        header = [[
,---.    ,---..-./`) ,---.   .--.   ____      _ _    .-'''-.              
|    \  /    |\ .-.')|    \  |  | .'  __ `.  ( ' )  / _     \             
|  ,  \/  ,  |/ `-' \|  ,  \ |  |/   '  \  \(_{;}_)(`' )/`--'             
|  |\_   /|  | `-'`"`|  |\_ \|  ||___|  /  | (_,_)(_ o _).                
|  _( )_/ |  | .---. |  _( )_\  |   _.-`   |       (_,_). '.              
| (_ o _) |  | |   | | (_ o _)  |.'   _    |      .---.  \  :             
|  (_,_)  |  | |   | |  (_,_)\  ||  _( )_  |      \    `-'  |             
|  |      |  | |   | |  |    |  |\ (_ o _) /       \       /              
'--'      '--' '---' '--'    '--' '.(_,_).'         `-...-'               
  .-_'''-.      ____    .-------.     ______         .-''-.  ,---.   .--. 
 '_( )_   \   .'  __ `. |  _ _   \   |    _ `''.   .'_ _   \ |    \  |  | 
|(_ o _)|  ' /   '  \  \| ( ' )  |   | _ | ) _  \ / ( ` )   '|  ,  \ |  | 
. (_,_)/___| |___|  /  ||(_ o _) /   |( ''_'  ) |. (_ o _)  ||  |\_ \|  | 
|  |  .-----.   _.-`   || (_,_).' __ | . (_) `. ||  (_,_)___||  _( )_\  | 
'  \  '-   .'.'   _    ||  |\ \  |  ||(_    ._) ''  \   .---.| (_ o _)  | 
 \  `-'`   | |  _( )_  ||  | \ `'   /|  (_.\.' /  \  `-'    /|  (_,_)\  | 
  \        / \ (_ o _) /|  |  \    / |       .'    \       / |  |    |  | 
   `'-...-'   '.(_,_).' ''-'   `'-'  '-----'`       `'-..-'  '--'    '--' 
]],
      },
      sections = {
        { section = "header" },
        { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
        { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        { section = "startup" },
      },
    },
    lazygit = {
      enabled = true,
    },
    git = {
      enabled = true,
    },
    picker = {
      hidden = true,
      ignored = true,
      sources = {
        files = {
          hidden = true,
          ignored = true,
        },
      },
    },
    image = {
      enabled = true,
    },
  },
}
