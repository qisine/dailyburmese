module UtilityFilters
  def top_n_posts(posts, num = 5)
    posts.select {|p| p.categories.first == "unicode" }
      .sort_by {|p| -p.date.to_f}
      .take(num)
      .sort_by {|p| p.date.to_f }
  end

  def compare_urls(current, other)
    c, o = [current, other].map {|u| u.gsub("index.html", "").split("/").reject {|e| e.empty? }}
    #puts "#{c.include?("unicode") && o.include?("unicode")}: [#{c}, #{o}]"
    return (c[0].nil? && o[0].nil?) ||
           (c.include?("unicode") && o.include?("unicode")) ||
           (c.include?("zawgyi") && o.include?("zawgyi")) ||
           (c.size == 1 && o.size == 1 && c[0] == o[0])
  end

  def index_by_first_letter(posts)
    idx = Hash.new { |h,k| h[k] = [] }
    posts.select { |p| p.categories.first == "unicode" && p.data["keywords"] }.each do |p|
      p.data["kwd_hash"].each_pair do |kwd, url|
        idx[kwd[0].downcase] << [url, kwd] unless idx[kwd[0].downcase].find {|e| e[0] == url && e[1] == kwd}
      end
    end
    idx.to_a.sort_by { |e| e[0].downcase }
  end
end

Liquid::Template.register_filter(UtilityFilters)
