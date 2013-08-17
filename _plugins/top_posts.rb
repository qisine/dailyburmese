module TopPostFilter
  def top_n_posts(posts, num = 5)
    posts.select {|p| p.categories.first == "unicode" }
      .sort_by {|p| -p.date.to_f}
      .take(num)
      .sort_by {|p| p.date.to_f }
  end
end

Liquid::Template.register_filter(TopPostFilter)
