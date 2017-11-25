# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

# Layouts
# https://middlemanapp.com/basics/layouts/

# Output to docs, for Github Pages use
set :build_dir, '../rock-monkey/'

# Load classes
Dir.glob('./lib/*.rb', &method(:require))

# Ensure all pages are preloaded and parsed
pages = Page.all

# Wiki pages
pages.each do |page|
  proxy "/#{page.tag}/index.html", "/template.html", locals: { page: page }
end
proxy "/index.html", "/template.html", locals: { page: Page.find_by_tag('HomePage') }
ignore "/template.html"

# JSON outputs
proxy "/tag-index.json", "/template.json", layout: nil, locals: { object: pages.map(&:tag) }
proxy "/search-index.json", "/template.json", layout: nil, locals: { object: pages.map{|p| { tag: p.tag, body: p.body }} }
proxy "/missing-pages.json", "/template.json", layout: nil, locals: { object: Page.missing_pages }
ignore "/template.json"

# Other pages
proxy "/help.html", "/content.html", locals: { page: nil, title: "Help!", content: <<-EOF
  <h2>Help! What is this place?</h2>
  <p>
    In the early years of the 21st century, a young man named <a href="/AndyKeohane">Andy Keohane</a> ran a wiki-based site,
    <a href="/RockMonkey">RockMonkey</a>, primarily for his friends around <a href="/AberystwythTown">Aberystwyth</a> where
    he was (and many of them were) <a href="/Students">students</a>.
  </p>
  <p>
    The site died in late 2007 and the domain name was allowed to lapse. But in a fit of nostalgia a decade later, former
    contributor <a href="https://danq.me/">Dan Q</a> brought it back as a static site for everybody to... umm... enjoy?
  </p>
  <p>
    And here it is.
  </p>
EOF
}
ignore "/content.html"

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

# proxy(
#   '/this-page-has-no-template.html',
#   '/template-file.html',
#   locals: {
#     which_fake_page: 'Rendering a fake page with a local variable'
#   },
# )

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

# helpers do
#   def some_helper
#     'Helping'
#   end
# end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

# configure :build do
#   activate :minify_css
#   activate :minify_javascript
# end
