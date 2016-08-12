import os
import re
import requests

def red(text):
  return "\033[0;31m{}\033[1;0m".format(text)

def green(text):
  return "\033[0;32m{}\033[1;0m".format(text)

def yellow(text):
  return "\033[0;33m{}\033[1;0m".format(text)

# Returns a list of files in a directory. Recursive. Returns full pahts.
def all_files_in_dir(directory):
  files = []
  for dirname, dirnames, filenames in os.walk(directory):
    for filename in filenames:
      files.append(os.path.join(dirname, filename))
  return files

# Returns a set of all links from a given string. Links can not include ')' or '"'.
def links_from_string(string):
  return set(re.findall(r'(https?://[^\)\"\'\s]+)', string))

# Returns true if a given link is reachable, false otherwise.
def link_is_healthy(link):
  r = requests.head(link)
  if r.status_code in (200, 301, 302):
    return True
  else:
    print("  [INFO] Status Code = {} when checking {}".format(r.status_code, link))
    return False

# For each file found, search for links and verify each one. Print the results.
pass_count = 0
fail_count = 0
for file in all_files_in_dir('.'):

  if file.startswith("./.git/") or file.startswith("./.sass-cache"):
    continue

  print("Checking {} for link rot...".format(file))

  content = open(file, 'r').read()
  links = links_from_string(content)

  for link in links:
    if link_is_healthy(link):
      pass_count += 1
      if link.startswith('https://'):
        print("  [{}] {}".format(green("PASS"), link))
      else:
        print("  [{}] {} {}".format(yellow("PASS"), link, yellow("(NON HTTPS)")))
    else:
      fail_count += 1
      print("  [{}] {}".format(red("FAIL"), link))

print("")
print("Found {} links in total.".format(pass_count + fail_count))
print("  [{}]: {}".format(green("PASS"), pass_count))
print("  [{}]: {}".format(red("FAIL"), fail_count))
