from pelican import signals
from pelican.contents import Tag

def add_category(generator):
    tag = Tag('mozilla', generator.settings)
    for article in generator.articles:
        if not hasattr(article, 'tags'):
            setattr(article, 'tags', [tag,])

def register():
    signals.article_generator_pretaxonomy.connect(add_category)
