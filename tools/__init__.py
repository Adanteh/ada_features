"""
    These are all tools for mod development.
"""

import colorama
from ansimarkup import AnsiMarkup, parse
from pathlib import Path

ROOT_FOLDER = Path(__file__).parents[1]

colorama.init()
user_tags = {
    # Add a new tag (e.g. we want <info> to expand to "<bold><green>").
    "error": parse("<K><r><b>")
}

am = AnsiMarkup(tags=user_tags)


def print(*args, **kwargs):
    """AnsiMarkup print wrapper with custom tags"""
    am.ansiprint(*args, **kwargs)
