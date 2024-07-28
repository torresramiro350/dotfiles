return {
  "Civitasv/cmake-tools.nvim",
  init = function()
    -- load the plugin only if the current directory contains a CMakeLists.txt file
    local cwd = vim.uv.cwd()
    if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
      return true
    end
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
  -- ft = { "cmake" },
  event = { "BufReadPre", "BufReadPost", "BufNewFile" },
}
