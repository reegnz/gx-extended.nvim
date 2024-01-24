local M = {}

function M.setup(config)
  require("gx-extended.lib").register {
    patterns = { "*" },
    name = "no-protocol-urls",
    match_to_url = function(line_string)
      local patterns_with_http_s = "(https?://[a-zA-Z0-9_/%-.~@#+=?&%%A-Fa-f]+)"
      local patterns_without_http_s = "([a-zA-Z0-9_/%-.~@#+?&%%A-Fa-f]+)"

      local col = vim.fn.col "."
      local match_start, match_end, url = string.find(line_string, patterns_with_http_s)
      if url and match_start <= col and match_end >= col then
        return url
      end
      match_start, match_end, url = string.find(line_string, patterns_without_http_s)
      if not url or match_start > col or match_end < col then
        return nil
      end
      -- Validate that it starts with a valid-ish domain
      if not string.match(url, "%S+%.%S+%.[%w%.]+/?.*") then
        return nil
      end
      if url then
        url = "https://" .. url
      end
      return url
    end,
  }
end

return M
