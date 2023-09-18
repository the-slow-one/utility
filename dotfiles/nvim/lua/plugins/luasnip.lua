return {
  "L3MON4D3/LuaSnip",
  version = "2.0.0",
  lazy = true,
  config = function ()
   require("luasnip.loaders.from_vscode").lazy_load()
  end
}
