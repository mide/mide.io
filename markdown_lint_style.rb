# frozen_string_literal: true

all

# Configurations ==============================================================

# MD002 - First header should be a top level header
# All of my pages have H1 driven by the {{ page.title }}, so the first Markdown
# header should really be level 2 ("##" and not "#").
rule 'MD002', level: 2

# MD003 - Header style
# I perfer to use ATX style headers ("# Title" or "## Subtitle") since they are
# more consistent once you get past three levels.
rule 'MD003', style: :atx

# MD004 - Unordered list style
# I perfer to use only dashes to signify an unordered list - and to keep that
# consistent across my entire site, I'll enforce that here.
rule 'MD004', style: :dash

# MD029 - Ordered list item prefix
# I like using "1." as the ordered list prefix because it makes diffing much
# easier - You don't see all the little changes related to the numbering.
rule 'MD029', style: :one

# MD035 - Horizontal rule style
# I don't really feel stronly about this one, but I just want to have
# consistency across my entire codebase. I don't even think I use any
# horizontal rules at this point.
rule 'MD035', style: '---'

# Exclusions ==================================================================

# MD033 - Inline HTML
# While not often, I do use inline HTML and I don't think there is anything
# wrong with it in this case. I'll completely ignore the rule.
exclude_rule 'MD033'

# MD013 - Line length
# Many of my blog posts are written on a single line, with word-wrap in my
# editor. I just don't like having to manually deal with line breaks when
# editing and how the resulting HTML looks.
exclude_rule 'MD013'

exclude_rule 'MD041' # First line in file should be a top level header
exclude_rule 'MD039' # BUG
exclude_rule 'MD002' # jsut for index
