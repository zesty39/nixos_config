import os
import pickle
import sys

cache_file = sys.argv[1]
records = {}

if os.path.exists(cache_file) and os.path.getsize(cache_file) > 0:
    try:
        with open(cache_file, "rb") as reader:
            records = pickle.load(reader)
    except Exception:
        records = {}

records["startup_hotkey_notification"] = True

with open(cache_file, "wb") as writer:
    pickle.dump(records, writer, 2)
