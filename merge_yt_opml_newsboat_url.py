import xml.etree.ElementTree as ET
import re
import requests

# CONFIG
EXISTING_URLS_FILE = "/home/ben/.config/newsboat/youtube/urls" # Update this path
NEW_OPML_FILE = "youtube_subs.opml"
OUTPUT_FILE = "merged_urls.txt"

def get_channel_title(feed_url):
    """Fetches the RSS feed to grab the channel title if missing."""
    try:
        r = requests.get(feed_url, timeout=5)
        if r.status_code == 200:
            root = ET.fromstring(r.content)
            # YouTube Atom feeds use the namespace, usually {http://www.w3.org/2005/Atom}title
            ns = {'atom': 'http://www.w3.org/2005/Atom'}
            return root.find('atom:title', ns).text
    except Exception as e:
        print(f"Failed to fetch title for {feed_url}: {e}")
    return "Unknown Channel"

unique_feeds = {}

# 1. Parse OPML (New data with titles)
try:
    tree = ET.parse(NEW_OPML_FILE)
    root = tree.getroot()
    for outline in root.findall(".//outline"):
        url = outline.get('xmlUrl')
        title = outline.get('title')
        if url:
            unique_feeds[url] = {'title': title, 'tags': ['youtube']}
except FileNotFoundError:
    print("No OPML file found, skipping...")

# 2. Parse Existing Urls file (Legacy data)
try:
    with open(EXISTING_URLS_FILE, 'r') as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith('#'): continue

            parts = line.split()
            url = parts[0]
            
            # Simple check if it's a YouTube URL
            if 'youtube.com' not in url: 
                # Preserve non-youtube feeds exactly as is
                # (You might want to implement a separate list for them)
                continue 

            current_tags = []
            current_title = None

            # Parse tags and title
            for part in parts[1:]:
                if part.startswith('"~'):
                    current_title = part.strip('"~')
                else:
                    current_tags.append(part.strip('"'))

            # If we already have this URL from OPML, merge tags, but OPML title wins (usually cleaner)
            if url in unique_feeds:
                unique_feeds[url]['tags'].extend(current_tags)
                unique_feeds[url]['tags'] = list(set(unique_feeds[url]['tags']))
            else:
                # If we don't have a title, fetch it!
                if not current_title:
                    print(f"Fetching missing title for: {url}")
                    current_title = get_channel_title(url)
                
                unique_feeds[url] = {
                    'title': current_title, 
                    'tags': current_tags if current_tags else ['youtube']
                }

except FileNotFoundError:
    print("No existing urls file found.")

# 3. Write Output
with open(OUTPUT_FILE, 'w') as f:
    for url, data in unique_feeds.items():
        # Clean title to avoid syntax errors
        title = data['title'].replace('"', "'")
        tags_str = " ".join([f'"{t}"' for t in data['tags']])
        f.write(f'{url} {tags_str} "~{title}"\n')

print(f"Done! Check {OUTPUT_FILE}")
