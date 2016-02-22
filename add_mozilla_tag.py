from pelican import signals

def add_category(generator):
    for article in generator.articles:
        setattr(article, 'tags', ['mozilla'])

def register():
    signals.article_generator_finalized.connect(add_category)
