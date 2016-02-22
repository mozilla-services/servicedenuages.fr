from pelican import signals

def add_category(generator):
    for article in generator.articles:
        if hasattr(article, 'tags'):
            article.tags.append('mozilla')
        else:
            setattr(article, 'tags', ['mozilla'])

def register():
    signals.article_generator_finalized.connect(add_category)
