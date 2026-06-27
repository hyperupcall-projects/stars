# frozen_string_literal: true

Jekyll::Hooks.register :documents, :pre_render do |document|
  github_user = "hyperupcall"
  github_repo = "dotfiles"
  github_branch = "trunk"

  next unless document.output_ext == ".html"

  document.content = document.content.gsub(/\[([^\]]+)\]\((\/)([^)]+)\)/) do |match|
    link_text = $1
    path = $3

    if path.end_with?('/') || !path.include?('.')
      "[#{link_text}](https://github.com/#{github_user}/#{github_repo}/tree/#{github_branch}/#{path}){:target=\"_blank\"}"
    else
      "[#{link_text}](https://github.com/#{github_user}/#{github_repo}/blob/#{github_branch}/#{path}){:target=\"_blank\"}"
    end
  end
end

Jekyll::Hooks.register :pages, :pre_render do |page|
  github_user = "hyperupcall"
  github_repo = "dotfiles"
  github_branch = "trunk"

  next unless page.output_ext == ".html"

  page.content = page.content.gsub(/\[([^\]]+)\]\((\/)([^)]+)\)/) do |match|
    link_text = $1
    path = $3

    if path.end_with?('/') || !path.include?('.')
      "[#{link_text}](https://github.com/#{github_user}/#{github_repo}/tree/#{github_branch}/#{path}){:target=\"_blank\"}"
    else
      "[#{link_text}](https://github.com/#{github_user}/#{github_repo}/blob/#{github_branch}/#{path}){:target=\"_blank\"}"
    end
  end
end
