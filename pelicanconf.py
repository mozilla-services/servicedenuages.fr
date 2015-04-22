#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHORS = (
    u'Rémy Hubscher',
    u'Mathieu Leplatre',
    u'Alexis Métaireau',
    u'Tarek Ziadé',
    u'Nicolas Perriault'
)
AUTHOR = "Service de Nuages"

SITENAME = u'Service de nuages'
SITEURL = ''

PATH = 'content'

TIMEZONE = 'Europe/Paris'

DEFAULT_LANG = u'fr'

# Social widget
SOCIAL = (('Github', 'https://github.com/mozilla-services'),)

DEFAULT_PAGINATION = False

THEME = "pure"

COVER_IMG_URL = '/theme/sidebar.jpg'

SOCIAL = (
    ('envelope', 'http://librelist.com/browser/daybed.dev/'),
    ('rss', SITEURL + 'feeds/all.atom.xml'),
    ('github', 'https://github.com/mozilla-services'),
)

MENUITEMS = (
    ('Archives', '/archives.html'),
)
STATIC_PATHS = ['images', 'documents', 'extra/CNAME', 'presentations']
EXTRA_PATH_METADATA = {'extra/CNAME': {'path': 'CNAME'}}

PLUGIN_PATHS = ['plugins']
PLUGINS = ['post_stats', 'better_figures_and_images']
RESPONSIVE_IMAGES = True
