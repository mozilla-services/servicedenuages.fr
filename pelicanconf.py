#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = u'Da French Team'
SITENAME = u'Service de nuages'
SITEURL = ''

PATH = 'content'

TIMEZONE = 'Europe/Paris'

DEFAULT_LANG = u'fr'

# Social widget
SOCIAL = (('Github', 'https://github.com/mozilla-services'),)

DEFAULT_PAGINATION = False

THEME = "pure"

TAGLINE = u"Passage à l'échelle de services web"
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
PLUGINS = ['post_stats', ]
