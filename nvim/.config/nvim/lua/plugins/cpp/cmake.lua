return {
  "Civitasv/cmake-tools.nvim",
  -- ft = { "cmake" },
  -- event = { "BufRead CMakeLists.txt" },
  lazy = true,
  init = function()
    -- load the plugin only if the current directory contains a CMakeLists.txt file
    local loaded = false
    local function check()
      local cwd = vim.uv.cwd()
      if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
        -- return true
        require("lazy").load({ plugins = { "cmake-tools.nvim" } })
        loaded = true
      end
    end

    check()

    vim.api.nvim_create_autocmd("DirChanged", {
      callback = function()
        if not loaded then
          check()
        end
      end,
    })
  end,
  config = function()
    local home = os.getenv("HOME")
    require("cmake-tools").setup({
      cmake_command = "cmake",
      ctest_command = "ctest",
      cmake_build_directory = "build/${variant:buildType}",
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
      cmake_kits_path = home .. "/cmake-kits/cmake-kits.json",
    })
    vim.keymap.set("n", "<leader>cg", "<cmd>CMakeGenerate<cr>", { desc = "CMake Generate" })
    vim.keymap.set("n", "<leader>cb", "<cmd>CMakeBuild<cr>", { desc = "CMake Build" })
    vim.keymap.set("n", "<leader>cc", "<cmd>CMakeClean<cr>", { desc = "CMake Clean" })
    vim.keymap.set("n", "<leader>ci", "<cmd>CMakeInstall<cr>", { desc = "CMake Install" })
  end,
}
