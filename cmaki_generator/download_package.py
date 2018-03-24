import urllib.request

def download_from_url(url, filename):
    local_filename, headers = urllib.request.urlretrieve(url)
    html = open(filename)
    html.close()
    return urllib2.urlretrieve(url, filename=filename)

url = "http://artifacts.myftp.biz/download.php?file=sdl2-2.0.3.0-linux_64_glibc_2.23-gcc_5-debug-cmake.tar.gz"

print( download_from_url(url, "sdl2-2.0.3.0-linux_64_glibc_2.23-gcc_5-debug-cmake.tar.gz") )

