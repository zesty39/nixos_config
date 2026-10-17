import argparse
import fcntl
import io
import json
import math
from pathlib import Path
import re
import sys
import time
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

from PIL import Image


def fetch(url):
    request = Request(url, headers={"User-Agent": "sekai-wallpapers-sync/1.0"})
    with urlopen(request, timeout=60) as response:
        return response.read()


def is_usable_image(path):
    if not path.is_file() or path.suffix.lower() not in {
        ".webp", ".png", ".jpg", ".jpeg", ".bmp", ".gif"
    }:
        return False
    try:
        with Image.open(path) as image:
            image.verify()
        return True
    except (OSError, ValueError):
        return False


def has_wallpapers(directory):
    return directory.exists() and any(is_usable_image(path) for path in directory.iterdir())


def synchronize(args):
    cards = json.loads(fetch(args.cards_url))
    selected = [
        card for card in cards
        if card["characterId"] == args.character_id
        and card.get("releaseAt", 0) <= time.time() * 1000
    ]
    if not selected:
        raise ValueError("No released cards found for the selected character")

    downloaded = 0
    failures = 0
    for card in selected:
        bundle = card["assetbundleName"]
        if not re.fullmatch(r"[A-Za-z0-9_-]+", bundle):
            raise ValueError(f"Invalid asset bundle name: {bundle!r}")
        variants = ["normal"]
        if card["cardRarityType"] in ("rarity_3", "rarity_4"):
            variants.append("after_training")
        for variant in variants:
            destination = args.directory / f"{bundle}_card_{variant}.webp"
            if is_usable_image(destination):
                continue
            url = f"{args.assets_url.rstrip('/')}/character/member/{bundle}/card_{variant}.webp"
            try:
                data = fetch(url)
                with Image.open(io.BytesIO(data)) as image:
                    image.verify()
                temporary = destination.with_suffix(".part")
                try:
                    temporary.write_bytes(data)
                    temporary.replace(destination)
                finally:
                    temporary.unlink(missing_ok=True)
                downloaded += 1
                print(f"Downloaded {destination.name}", flush=True)
            except (HTTPError, URLError, TimeoutError, OSError, ValueError) as error:
                failures += 1
                print(f"Failed to download {url}: {error}", file=sys.stderr)
    print(f"Cards: {len(selected)}; downloaded: {downloaded}; failed: {failures}")
    return 1 if failures else 0


def run_once(args):
    args.directory.mkdir(parents=True, exist_ok=True)
    with (args.directory / ".sync.lock").open("w") as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            print("A wallpaper synchronization is already running")
            return 0
        try:
            return synchronize(args)
        except (URLError, TimeoutError, OSError, ValueError, KeyError) as error:
            print(f"Wallpaper synchronization failed: {error}", file=sys.stderr)
            return 1


def save_next_sync(state_file, timestamp):
    temporary = state_file.with_suffix(".tmp")
    temporary.write_text(json.dumps({"next_sync": timestamp}))
    temporary.replace(state_file)


def run_schedule(args):
    interval = args.interval_days * 86400
    args.state_file.parent.mkdir(parents=True, exist_ok=True)
    if args.state_file.exists():
        next_sync = json.loads(args.state_file.read_text())["next_sync"]
        if not isinstance(next_sync, (int, float)) or not math.isfinite(next_sync):
            raise ValueError("Invalid next synchronization timestamp")
    else:
        next_sync = time.time() + interval
        save_next_sync(args.state_file, next_sync)

    if not has_wallpapers(args.directory):
        print("No usable wallpapers found; synchronizing immediately", flush=True)
        next_sync = time.time()

    while True:
        remaining = next_sync - time.time()
        if remaining > 0:
            time.sleep(min(remaining, 3600))
            continue
        # Persist the next attempt before downloading to avoid repeats after a restart.
        next_sync = time.time() + interval
        save_next_sync(args.state_file, next_sync)
        if run_once(args) != 0:
            next_sync = time.time() + 60
            save_next_sync(args.state_file, next_sync)


def main():
    parser = argparse.ArgumentParser(description="Download Sekai card wallpapers")
    parser.add_argument("--character-id", type=int, default=5)
    parser.add_argument("--directory", type=Path,
                        default=Path.home() / "Pictures/Wallpapers/minori")
    parser.add_argument("--cards-url", default=
                        "https://sekai-world.github.io/sekai-master-db-diff/cards.json")
    parser.add_argument("--assets-url", default=
                        "https://storage.sekai.best/sekai-jp-assets")
    parser.add_argument("--interval-days", type=float, default=0,
                        help="Persist a recurring schedule; zero synchronizes immediately")
    parser.add_argument("--state-file", type=Path,
                        help="Path to the persistent synchronization schedule")
    args = parser.parse_args()
    if not math.isfinite(args.interval_days) or args.interval_days < 0:
        parser.error("--interval-days must be a finite, nonnegative number")
    if args.interval_days > 0:
        if args.state_file is None:
            parser.error("--state-file is required with --interval-days")
        return run_schedule(args)
    return run_once(args)


if __name__ == "__main__":
    sys.exit(main())
