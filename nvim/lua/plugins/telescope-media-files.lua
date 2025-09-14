return {
  "nvim-lua/popup.nvim",
  "nvim-telescope/telescope-media-files.nvim",
  opts = function()
    require("telescope").load_extension("media_files")
  end,
}
