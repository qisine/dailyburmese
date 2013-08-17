module UtilityFilters
  def top_n_posts(posts, num = 5)
    posts.select {|p| p.categories.first == "unicode" }
      .sort_by {|p| -p.date.to_f}
      .take(num)
      .sort_by {|p| p.date.to_f }
  end

  def compare_urls(current, other)
    c, o = [current, other].map {|u| u.gsub("index.html", "").split("/").reject {|e| e.empty? }}
    puts "#{c.include?("unicode") && o.include?("unicode")}: [#{c}, #{o}]"
    return (c[0].nil? && o[0].nil?) ||
           (c.include?("unicode") && o.include?("unicode")) ||
           (c.include?("zawgyi") && o.include?("zawgyi")) ||
           (c.size == 1 && o.size == 1 && c[0] == o[0])
  end
end

Liquid::Template.register_filter(UtilityFilters)
