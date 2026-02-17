import asyncio
import aiohttp
import aiofiles
from pathlib import Path
from urllib.parse import urlparse
import time
from typing import List

class DownloadResult:
    def __init__(self, url: str, status: str):
        self.url = url
        self.status = status

class ImageDownloader:
    def __init__(self, download_path: str):
        self.download_path = Path(download_path)
        self.tasks: List[asyncio.Task] = []
        self.results: List[DownloadResult] = []
    
    def validate_path(self, path: str) -> bool:
        try:
            path_obj = Path(path)
            if not path_obj.exists():
                path_obj.mkdir(parents=True, exist_ok=True)
            test_file = path_obj / ".test_write"
            test_file.write_text("test")
            test_file.unlink()
            return True
        except (OSError, PermissionError):
            return False
    
    def extract_filename_from_url(self, url: str) -> str:
        parsed = urlparse(url)
        filename = Path(parsed.path).name
        if not filename or '.' not in filename:
            timestamp = int(time.time() * 1000)
            filename = f"image_{timestamp}.jpg"
        return filename
    
    async def download_single_image(self, session: aiohttp.ClientSession, url: str) -> DownloadResult:
        filename = self.extract_filename_from_url(url)
        filepath = self.download_path / filename
        try:
            async with session.get(url, timeout=aiohttp.ClientTimeout(total=30)) as response:
                if response.status == 200:
                    counter = 1
                    original_filepath = filepath
                    while filepath.exists():
                        name_part = original_filepath.stem
                        ext_part = original_filepath.suffix
                        filepath = self.download_path / f"{name_part}_{counter}{ext_part}"
                        counter += 1
                    async with aiofiles.open(filepath, 'wb') as file:
                        async for chunk in response.content.iter_chunked(8192):
                            await file.write(chunk)
                    return DownloadResult(url, "Успех")
                else:
                    return DownloadResult(url, "Ошибка")
        except Exception:
            return DownloadResult(url, "Ошибка")

def get_valid_download_path() -> str:
    path = input().strip()
    downloader_temp = ImageDownloader(path)
    if downloader_temp.validate_path(path):
        return path
    else:
        print("Некорректный путь или нет доступа. Введите другой путь.")
        return get_valid_download_path()

def display_summary(results: List[DownloadResult]) -> None:
    if not results:
        return
    print("Сводка об успешных и неуспешных загрузках")
    print()
    max_url_length = max(len(result.url) for result in results)
    max_url_length = max(max_url_length, len("Ссылка"))
    header_line = f"+{'-' * (max_url_length + 2)}+{'-' * 8}+"
    print(header_line)
    print(f"| {'Ссылка':<{max_url_length}} | Статус |")
    print(header_line)
    for result in results:
        print(f"| {result.url:<{max_url_length}} | {result.status:>6} |")
    print(header_line)

async def main():
    download_path = get_valid_download_path()
    downloader = ImageDownloader(download_path)
    
    async with aiohttp.ClientSession() as session:
        while True:
            url = input().strip()
            if not url:
                break
            task = asyncio.create_task(downloader.download_single_image(session, url))
            downloader.tasks.append(task)
        
        if downloader.tasks:
            unfinished = [t for t in downloader.tasks if not t.done()]
            if unfinished:
                print("Не все изображения загружены. Ожидание завершения...")
            results = await asyncio.gather(*downloader.tasks)
            downloader.results = results
    
    display_summary(downloader.results)

if __name__ == "__main__":
    asyncio.run(main())