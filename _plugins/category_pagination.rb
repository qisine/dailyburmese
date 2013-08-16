module Jekyll
  class CategoryPaginator < Generator
    def generate(site)
      puts "posts: #{site.posts.size}"
      site.categories.each {|c| paginate(site, c) }
    end

    def paginate(site, category)
      count = Pager.calculate_pages(site.posts, site.config['paginate'].to_i)
    end
  end

  class CategoryPage < Page
    def initialize(site, base, dir, type, val)
    end
  end
end
